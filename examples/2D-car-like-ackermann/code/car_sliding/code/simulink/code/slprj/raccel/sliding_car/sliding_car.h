#include "__cf_sliding_car.h"
#ifndef RTW_HEADER_sliding_car_h_
#define RTW_HEADER_sliding_car_h_
#include <stddef.h>
#include <math.h>
#include <string.h>
#include "rtw_modelmap.h"
#ifndef sliding_car_COMMON_INCLUDES_
#define sliding_car_COMMON_INCLUDES_
#include <stdlib.h>
#include "rtwtypes.h"
#include "simtarget/slSimTgtSigstreamRTW.h"
#include "simtarget/slSimTgtSlioCoreRTW.h"
#include "simtarget/slSimTgtSlioClientsRTW.h"
#include "sigstream_rtw.h"
#include "simstruc.h"
#include "fixedpoint.h"
#include "raccel.h"
#include "slsv_diagnostic_codegen_c_api.h"
#include "rt_logging.h"
#include "dt_info.h"
#include "ext_work.h"
#endif
#include "sliding_car_types.h"
#include "multiword_types.h"
#include "rtGetNaN.h"
#include "rt_nonfinite.h"
#include "rtGetInf.h"
#include "mwmathutil.h"
#include "rt_defines.h"
#define MODEL_NAME sliding_car
#define NSAMPLE_TIMES (2) 
#define NINPUTS (0)       
#define NOUTPUTS (0)     
#define NBLOCKIO (5) 
#define NUM_ZC_EVENTS (0) 
#ifndef NCSTATES
#define NCSTATES (12)   
#elif NCSTATES != 12
#error Invalid specification of NCSTATES defined in compiler command
#endif
#ifndef rtmGetDataMapInfo
#define rtmGetDataMapInfo(rtm) (*rt_dataMapInfoPtr)
#endif
#ifndef rtmSetDataMapInfo
#define rtmSetDataMapInfo(rtm, val) (rt_dataMapInfoPtr = &val)
#endif
#ifndef IN_RACCEL_MAIN
#endif
typedef struct { real_T n01yyskxy4 [ 81 ] ; } mnc2uupdn3 ; typedef struct {
real_T hkbmt1bwgv [ 12 ] ; real_T mx5qtfxqqb [ 3 ] ; real_T m2wc2u3tke [ 12 ]
; mnc2uupdn3 lyhikfrpp3 ; mnc2uupdn3 fdaowiniar ; } B ; typedef struct {
struct { void * LoggedData ; } ftipop2ikq ; } DW ; typedef struct { real_T
fy10ebt42l [ 12 ] ; } X ; typedef struct { real_T fy10ebt42l [ 12 ] ; } XDot
; typedef struct { boolean_T fy10ebt42l [ 12 ] ; } XDis ; typedef struct {
real_T fy10ebt42l [ 12 ] ; } CStateAbsTol ; typedef struct {
rtwCAPI_ModelMappingInfo mmi ; } DataMapInfo ; struct P_ { real_T Cp_1 ;
real_T Cp_2 ; real_T Fz_1 ; real_T Fz_2 ; real_T Ic_33 ; real_T Ii_11 ;
real_T Ii_21 ; real_T Ii_22 ; real_T Ii_31 ; real_T Ii_32 ; real_T Ii_33 ;
real_T Il_11 ; real_T Il_21 ; real_T Il_22 ; real_T Il_31 ; real_T Il_32 ;
real_T Il_33 ; real_T Io_11 ; real_T Io_21 ; real_T Io_22 ; real_T Io_31 ;
real_T Io_32 ; real_T Io_33 ; real_T Ir_11 ; real_T Ir_21 ; real_T Ir_22 ;
real_T Ir_31 ; real_T Ir_32 ; real_T Ir_33 ; real_T L ; real_T Lc ; real_T R
; real_T a ; real_T g ; real_T mc ; real_T mi ; real_T ml ; real_T mo ;
real_T mr ; real_T mu_1 ; real_T mu_2 ; real_T w ; real_T x0 [ 12 ] ; real_T
Constant_Value [ 4 ] ; } ; extern const char * RT_MEMORY_ALLOCATION_ERROR ;
extern B rtB ; extern X rtX ; extern DW rtDW ; extern P rtP ; extern const
rtwCAPI_ModelMappingStaticInfo * sliding_car_GetCAPIStaticMap ( void ) ;
extern SimStruct * const rtS ; extern const int_T gblNumToFiles ; extern
const int_T gblNumFrFiles ; extern const int_T gblNumFrWksBlocks ; extern
rtInportTUtable * gblInportTUtables ; extern const char * gblInportFileName ;
extern const int_T gblNumRootInportBlks ; extern const int_T
gblNumModelInputs ; extern const int_T gblInportDataTypeIdx [ ] ; extern
const int_T gblInportDims [ ] ; extern const int_T gblInportComplex [ ] ;
extern const int_T gblInportInterpoFlag [ ] ; extern const int_T
gblInportContinuous [ ] ; extern const int_T gblParameterTuningTid ; extern
size_t gblCurrentSFcnIdx ; extern size_t * gblChildIdxToInfoIdx ; extern
DataMapInfo * rt_dataMapInfoPtr ; extern rtwCAPI_ModelMappingInfo *
rt_modelMapInfoPtr ; void MdlOutputs ( int_T tid ) ; void
MdlOutputsParameterSampleTime ( int_T tid ) ; void MdlUpdate ( int_T tid ) ;
void MdlTerminate ( void ) ; void MdlInitializeSizes ( void ) ; void
MdlInitializeSampleTimes ( void ) ; SimStruct * raccel_register_model ( void
) ;
#endif
