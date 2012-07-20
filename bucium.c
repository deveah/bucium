#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>

#include <portaudio.h>

#include <sndfile.h>


#define SAMPLE_RATE 44100
#define BUFFER_SIZE 512
#define AUDIO_CHANNELS 1
#define RENDER_FREQ 110

#define MAIN_LUA_FILE "bucium.lua"
#define OUTPUT_FILE "output.wav"

lua_State *L;

PaStream *stream;
SNDFILE *wave_output;

unsigned int globalFrame = 0;

static int audio_callback(	const void *inputBuffer, void *outputBuffer,
							unsigned long framesPerBuffer, 
							const PaStreamCallbackTimeInfo *timeInfo,
							PaStreamCallbackFlags statusFlags,
							void *userData )
{
	float *out = (float*)outputBuffer;

	int i;
	float r;

	lua_getglobal( L, "main" );
	int lr = lua_pcall( L, 0, 1, 0 );
	if( lr )
		printf( "%s\n", lua_tostring( L, -1 ) );

	for( i = 0; i < framesPerBuffer; i++ )
	{
		globalFrame++;
		if( globalFrame == SAMPLE_RATE ) globalFrame = 0;

		lua_rawgeti( L, -1, i+1 );
		out[i] = lua_tonumber( L, -1 );
		lua_pop( L, 1 );
	}

	sf_write_float( wave_output, out, framesPerBuffer );

	return paContinue;
}

void init_pa( void )
{
	PaStreamParameters outputParameters;
	PaError err;

	err = Pa_Initialize();
	outputParameters.device = Pa_GetDefaultOutputDevice();
	outputParameters.channelCount = AUDIO_CHANNELS;
	outputParameters.sampleFormat = paFloat32;
	outputParameters.suggestedLatency = Pa_GetDeviceInfo( outputParameters.device )->defaultLowOutputLatency;
	outputParameters.hostApiSpecificStreamInfo = NULL;
	
	err = Pa_OpenStream( &stream, NULL, &outputParameters, SAMPLE_RATE, BUFFER_SIZE, paClipOff, audio_callback, NULL );
}

void init_lua( int argc, char* argv[] )
{
	int i;

	L = lua_open();
	luaL_openlibs( L );

	lua_newtable( L );
	for( i = 0; i < argc-1; i++ )
	{
		lua_pushstring( L, argv[i+1] );
		lua_rawseti( L, -2, i+1 );
	}

	lua_setglobal( L, "args" );

	/* system variables table: */
	lua_newtable( L );
	lua_pushinteger( L, SAMPLE_RATE );
	lua_setfield( L, -2, "sampleRate" );
	lua_pushinteger( L, BUFFER_SIZE );
	lua_setfield( L, -2, "bufferSize" );
	lua_pushinteger( L, RENDER_FREQ );
	lua_setfield( L, -2, "freq" );
	lua_setglobal( L, "system" );

	luaL_dofile( L, MAIN_LUA_FILE );
	lua_getglobal( L, "init" );
	int r = lua_pcall( L, 0, 1, 0 );
	if( lua_toboolean( L, -1 ) == 0 )
		printf( "TODO handle initialization error.\n" );
	
	if( r )
		printf( lua_tostring( L, -1 ) );
}

void init_sf( void )
{
	SF_INFO sfinfo;

	sfinfo.samplerate = SAMPLE_RATE;
	sfinfo.channels = AUDIO_CHANNELS;
	sfinfo.format = SF_FORMAT_WAV | SF_FORMAT_FLOAT;

	wave_output = sf_open( OUTPUT_FILE, SFM_WRITE, &sfinfo );
}

int main( int argc, char* argv[] )
{
	PaError err;

	init_pa();
	init_sf();
	init_lua( argc, argv );

	err = Pa_StartStream( stream );
	Pa_Sleep( 1000 );

	err = Pa_StopStream( stream );
	err = Pa_CloseStream( stream );
	Pa_Terminate();
	sf_close( wave_output );

	return 0;
}
