// GGEMS Copyright (C) 2017

/*!
 * \file global.cu
 * \brief Global functions
 * \author J. Bert <bert.jul@gmail.com>
 * \version 0.4
 * \date december 2, 2015
 *
 * v0.4: JB - Change all structs and remove CPU exec
 */

#ifndef GLOBAL_CUH
#define GLOBAL_CUH

/////// INCLUDES ///////////////////////////////////////////////

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <string>
#include <vector>
#include <sstream>
#include <fstream>
#include <iterator>
#include <map>
#include <algorithm>
#include <cfloat>
#include <climits>
#include <assert.h>
#include <math.h>
#include <cstring>
#include <iostream>
#include <ctime>
#include <random>
#include <iomanip>

#include <cuda.h>
#include <curand_kernel.h>

#ifdef _WIN32
#include <time.h>
#include <Windows.h>
#else
#include <sys/time.h>
#endif

/////// CONSTANTS //////////////////////////////////////////////

// Maximum number of processes
#define NB_PROCESSES 20
// Maximum number of photon processes
#define NB_PHOTON_PROCESSES 3
// Maximum number of photon processes
#define NB_ELECTRON_PROCESSES 3
// Maximum number of different particles
#define NB_PARTICLES 5

// Type of particle
#define PHOTON 0
#define ELECTRON 1
#define POSITRON 2

// Photon processes
#define PHOTON_COMPTON 0
#define PHOTON_PHOTOELECTRIC 1
#define PHOTON_RAYLEIGH 2
#define PHOTON_BOUNDARY_VOXEL 3

// Electron processes
#define ELECTRON_IONISATION 4
#define ELECTRON_MSC 5
#define ELECTRON_BREMSSTRAHLUNG 6

// No processes
#define NO_PROCESS 99

// Particle state
#define PRIMARY 0
#define GEOMETRY_BOUNDARY 99
#define PARTICLE_ALIVE 0
#define PARTICLE_DEAD 1
#define PARTICLE_FREEZE 2

// Misc
#define DISABLED 0
#define ENABLED 1

#define STATE_SOLID 0
#define STATE_GAS 1

#define TRUE    1
#define FALSE   0

#define EKINELIMIT 1*eV

//#define DEBUGOK "[\033[32;01mok\033[00m]"
//#define PRINTFUNCTION printf("%s %s\n",DEBUGOK,__FUNCTION__);
#define HANDLE_ERROR( err ) (HandleError( err, __FILE__, __LINE__ ))

#define EPSILON2 1.0e-02f
#define EPSILON3 1.0e-03f
#define EPSILON6 1.0e-06f

#define GGcout std::cout << "[GGEMS] "
#define GGendl std::endl
#define GGcerr std::cerr << "[GGEMS error] "
#define GGcin std::cin << "[GGEMS input] "
#define GGwarn std::cout << "[GGEMS warning] "

////// DEBUG ///////////////////////////////////////////////////

#define DEBUG 1
//#define DEBUG_TRACK_ID 13470

/////// TYPEDEF ////////////////////////////////////////////////

#ifdef SINGLE_PRECISION
    // Single precision
    typedef float f32;
    typedef float2 f32xy;
    typedef float3 f32xyz;
    typedef float4 f32xyzw;

    typedef float f64;
    typedef float2 f64xy;
    typedef float3 f64xyz;
    typedef float4 f64xyzw;

    typedef int i32;
    typedef int2 i32xy;
    typedef int3 i32xyz;
    typedef int4 i32xyzw;

    typedef short int i16;
    typedef char i8;

    typedef unsigned int ui32;
    typedef uint2 ui32xy;
    typedef uint3 ui32xyz;
    typedef uint4 ui32xyzw;

    typedef unsigned long ui64;

    typedef unsigned short int ui16;
    typedef ushort2 ui16xy;
    typedef ushort3 ui16xyz;
    typedef ushort4 ui16xyzw;

    typedef unsigned char ui8;

    #define F32_MAX FLT_MAX;
    #define F64_MAX FLT_MAX;
#else
    // Double precision
    typedef float f32;
    typedef float2 f32xy;
    typedef float3 f32xyz;
    typedef float4 f32xyzw;

    typedef double f64;
    typedef double2 f64xy;
    typedef double3 f64xyz;
    typedef double4 f64xyzw;

    typedef int i32;
    typedef int2 i32xy;
    typedef int3 i32xyz;
    typedef int4 i32xyzw;

    typedef short int i16;
    typedef char i8;

    typedef unsigned int ui32;
    typedef uint2 ui32xy;
    typedef uint3 ui32xyz;
    typedef uint4 ui32xyzw;

    typedef unsigned short int ui16;
    typedef ushort2 ui16xy;
    typedef ushort3 ui16xyz;
    typedef ushort4 ui16xyzw;

    typedef unsigned long int ui64;

    typedef unsigned char ui8;

    #define F32_MAX FLT_MAX;
    #define F64_MAX DBL_MAX;
#endif


////////////////////////////////////////////////////////////////


//// Constants /////////////////////////////////////////////////

// Typedef must defined before including this file
#include "system_of_units.cuh"
#include "physical_constants.cuh"

////////////////////////////////////////////////////////////////

// Global simulation parameters
struct GlobalSimulationParametersData
{
    ui8* physics_list;
    ui8* secondaries_list;
    f32 photon_cut;    // In energy for now, need to change for distance range.
    f32 electron_cut;

    ui32 nb_of_secondaries;

    ui64 nb_of_particles;
    ui64 size_of_particles_batch;
    ui32 nb_of_batches;

    ui32 gpu_id;
    ui32 gpu_block_size;
    ui32 gpu_grid_size;
    f32 time;
    ui32 seed;

    bool display_run_time;
    bool display_memory_usage;
    bool display_in_color;
    bool display_energy_cuts;
    bool verbose;

    // Transport navigation tolerance
    f32 geom_tolerance;

    // To build cross sections table
    ui32 cs_table_nbins;
    f32 cs_table_min_E;
    f32 cs_table_max_E;
};

// GPU
void set_gpu_device ( int deviceChoice );
void reset_gpu_device();
void HandleError ( cudaError_t err, const char *file, int line );
void cuda_error_check ( const char * prefix, const char * postfix );

// Utils
void print_error ( std::string msg );
void print_warning ( std::string msg );

void print_banner(std::string version, GlobalSimulationParametersData *params );
void exit_simulation();

void GGcout_time ( std::string txt, f64 t );
void GGcout_mem ( std::string txt, ui64 valmem );
void GGcout_params(GlobalSimulationParametersData *params );
void GGcout_timestamp ();
void GGcout_version ();
void GGcout_def();
void GGnewline( );

std::string Energy_str( f32 E );
std::string Range_str( f32 E );

f64 get_time();


#endif
