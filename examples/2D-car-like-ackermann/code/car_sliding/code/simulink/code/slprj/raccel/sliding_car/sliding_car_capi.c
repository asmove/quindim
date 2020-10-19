#include "__cf_sliding_car.h"
#include "rtw_capi.h"
#ifdef HOST_CAPI_BUILD
#include "sliding_car_capi_host.h"
#define sizeof(s) ((size_t)(0xFFFF))
#undef rt_offsetof
#define rt_offsetof(s,el) ((uint16_T)(0xFFFF))
#define TARGET_CONST
#define TARGET_STRING(s) (s)    
#else
#include "builtin_typeid_types.h"
#include "sliding_car.h"
#include "sliding_car_capi.h"
#include "sliding_car_private.h"
#ifdef LIGHT_WEIGHT_CAPI
#define TARGET_CONST                  
#define TARGET_STRING(s)               (NULL)                    
#else
#define TARGET_CONST                   const
#define TARGET_STRING(s)               (s)
#endif
#endif
static const rtwCAPI_Signals rtBlockSignals [ ] = { { 0 , 0 , TARGET_STRING (
"sliding_car/Vehicle/Integrator" ) , TARGET_STRING ( "" ) , 0 , 0 , 0 , 0 , 0
} , { 1 , 0 , TARGET_STRING (
"sliding_car/Vehicle/Steering automobile model/Car subsystem/Matrix Concatenate"
) , TARGET_STRING ( "" ) , 0 , 0 , 0 , 0 , 0 } , { 2 , 0 , TARGET_STRING (
"sliding_car/Vehicle/Steering automobile model/Car subsystem/Product" ) ,
TARGET_STRING ( "" ) , 0 , 0 , 1 , 0 , 0 } , { 3 , 0 , TARGET_STRING (
"sliding_car/Vehicle/Steering automobile model/Car subsystem/Product1" ) ,
TARGET_STRING ( "" ) , 0 , 0 , 2 , 0 , 0 } , { 4 , 0 , TARGET_STRING (
 "sliding_car/Vehicle/Steering automobile model/Ideal, quasi and nonideal efforts/Sum1"
) , TARGET_STRING ( "" ) , 0 , 0 , 3 , 0 , 0 } , { 5 , 13 , TARGET_STRING (
"sliding_car/Vehicle/Steering automobile model/Mass block/inverse M" ) ,
TARGET_STRING ( "" ) , 0 , 0 , 4 , 0 , 0 } , { 6 , 14 , TARGET_STRING (
"sliding_car/Vehicle/Steering automobile model/Mass block/inverse M1" ) ,
TARGET_STRING ( "" ) , 0 , 0 , 4 , 0 , 0 } , { 0 , 0 , ( NULL ) , ( NULL ) ,
0 , 0 , 0 , 0 , 0 } } ; static const rtwCAPI_BlockParameters
rtBlockParameters [ ] = { { 7 , TARGET_STRING ( "sliding_car/Constant" ) ,
TARGET_STRING ( "Value" ) , 0 , 5 , 0 } , { 0 , ( NULL ) , ( NULL ) , 0 , 0 ,
0 } } ; static const rtwCAPI_ModelParameters rtModelParameters [ ] = { { 8 ,
TARGET_STRING ( "Cp_1" ) , 0 , 6 , 0 } , { 9 , TARGET_STRING ( "Cp_2" ) , 0 ,
6 , 0 } , { 10 , TARGET_STRING ( "Fz_1" ) , 0 , 6 , 0 } , { 11 ,
TARGET_STRING ( "Fz_2" ) , 0 , 6 , 0 } , { 12 , TARGET_STRING ( "Ic_33" ) , 0
, 6 , 0 } , { 13 , TARGET_STRING ( "Ii_11" ) , 0 , 6 , 0 } , { 14 ,
TARGET_STRING ( "Ii_21" ) , 0 , 6 , 0 } , { 15 , TARGET_STRING ( "Ii_22" ) ,
0 , 6 , 0 } , { 16 , TARGET_STRING ( "Ii_31" ) , 0 , 6 , 0 } , { 17 ,
TARGET_STRING ( "Ii_32" ) , 0 , 6 , 0 } , { 18 , TARGET_STRING ( "Ii_33" ) ,
0 , 6 , 0 } , { 19 , TARGET_STRING ( "Il_11" ) , 0 , 6 , 0 } , { 20 ,
TARGET_STRING ( "Il_21" ) , 0 , 6 , 0 } , { 21 , TARGET_STRING ( "Il_22" ) ,
0 , 6 , 0 } , { 22 , TARGET_STRING ( "Il_31" ) , 0 , 6 , 0 } , { 23 ,
TARGET_STRING ( "Il_32" ) , 0 , 6 , 0 } , { 24 , TARGET_STRING ( "Il_33" ) ,
0 , 6 , 0 } , { 25 , TARGET_STRING ( "Io_11" ) , 0 , 6 , 0 } , { 26 ,
TARGET_STRING ( "Io_21" ) , 0 , 6 , 0 } , { 27 , TARGET_STRING ( "Io_22" ) ,
0 , 6 , 0 } , { 28 , TARGET_STRING ( "Io_31" ) , 0 , 6 , 0 } , { 29 ,
TARGET_STRING ( "Io_32" ) , 0 , 6 , 0 } , { 30 , TARGET_STRING ( "Io_33" ) ,
0 , 6 , 0 } , { 31 , TARGET_STRING ( "Ir_11" ) , 0 , 6 , 0 } , { 32 ,
TARGET_STRING ( "Ir_21" ) , 0 , 6 , 0 } , { 33 , TARGET_STRING ( "Ir_22" ) ,
0 , 6 , 0 } , { 34 , TARGET_STRING ( "Ir_31" ) , 0 , 6 , 0 } , { 35 ,
TARGET_STRING ( "Ir_32" ) , 0 , 6 , 0 } , { 36 , TARGET_STRING ( "Ir_33" ) ,
0 , 6 , 0 } , { 37 , TARGET_STRING ( "L" ) , 0 , 6 , 0 } , { 38 ,
TARGET_STRING ( "Lc" ) , 0 , 6 , 0 } , { 39 , TARGET_STRING ( "R" ) , 0 , 6 ,
0 } , { 40 , TARGET_STRING ( "a" ) , 0 , 6 , 0 } , { 41 , TARGET_STRING ( "g"
) , 0 , 6 , 0 } , { 42 , TARGET_STRING ( "mc" ) , 0 , 6 , 0 } , { 43 ,
TARGET_STRING ( "mi" ) , 0 , 6 , 0 } , { 44 , TARGET_STRING ( "ml" ) , 0 , 6
, 0 } , { 45 , TARGET_STRING ( "mo" ) , 0 , 6 , 0 } , { 46 , TARGET_STRING (
"mr" ) , 0 , 6 , 0 } , { 47 , TARGET_STRING ( "mu_1" ) , 0 , 6 , 0 } , { 48 ,
TARGET_STRING ( "mu_2" ) , 0 , 6 , 0 } , { 49 , TARGET_STRING ( "w" ) , 0 , 6
, 0 } , { 50 , TARGET_STRING ( "x0" ) , 0 , 0 , 0 } , { 0 , ( NULL ) , 0 , 0
, 0 } } ;
#ifndef HOST_CAPI_BUILD
static void * rtDataAddrMap [ ] = { & rtB . hkbmt1bwgv [ 0 ] , & rtB .
m2wc2u3tke [ 0 ] , & rtB . m2wc2u3tke [ 0 ] , ( ( & rtB . m2wc2u3tke [ 0 ] )
+ 9 ) , & rtB . mx5qtfxqqb [ 0 ] , & rtB . fdaowiniar . n01yyskxy4 [ 0 ] , &
rtB . lyhikfrpp3 . n01yyskxy4 [ 0 ] , & rtP . Constant_Value [ 0 ] , & rtP .
Cp_1 , & rtP . Cp_2 , & rtP . Fz_1 , & rtP . Fz_2 , & rtP . Ic_33 , & rtP .
Ii_11 , & rtP . Ii_21 , & rtP . Ii_22 , & rtP . Ii_31 , & rtP . Ii_32 , & rtP
. Ii_33 , & rtP . Il_11 , & rtP . Il_21 , & rtP . Il_22 , & rtP . Il_31 , &
rtP . Il_32 , & rtP . Il_33 , & rtP . Io_11 , & rtP . Io_21 , & rtP . Io_22 ,
& rtP . Io_31 , & rtP . Io_32 , & rtP . Io_33 , & rtP . Ir_11 , & rtP . Ir_21
, & rtP . Ir_22 , & rtP . Ir_31 , & rtP . Ir_32 , & rtP . Ir_33 , & rtP . L ,
& rtP . Lc , & rtP . R , & rtP . a , & rtP . g , & rtP . mc , & rtP . mi , &
rtP . ml , & rtP . mo , & rtP . mr , & rtP . mu_1 , & rtP . mu_2 , & rtP . w
, & rtP . x0 [ 0 ] , } ; static int32_T * rtVarDimsAddrMap [ ] = { ( NULL ) }
;
#endif
static TARGET_CONST rtwCAPI_DataTypeMap rtDataTypeMap [ ] = { { "double" ,
"real_T" , 0 , 0 , sizeof ( real_T ) , SS_DOUBLE , 0 , 0 } } ;
#ifdef HOST_CAPI_BUILD
#undef sizeof
#endif
static TARGET_CONST rtwCAPI_ElementMap rtElementMap [ ] = { { ( NULL ) , 0 ,
0 , 0 , 0 } , } ; static const rtwCAPI_DimensionMap rtDimensionMap [ ] = { {
rtwCAPI_VECTOR , 0 , 2 , 0 } , { rtwCAPI_VECTOR , 2 , 2 , 0 } , {
rtwCAPI_VECTOR , 4 , 2 , 0 } , { rtwCAPI_VECTOR , 6 , 2 , 0 } , {
rtwCAPI_MATRIX_COL_MAJOR , 8 , 2 , 0 } , { rtwCAPI_VECTOR , 10 , 2 , 0 } , {
rtwCAPI_SCALAR , 12 , 2 , 0 } } ; static const uint_T rtDimensionArray [ ] =
{ 12 , 1 , 1 , 9 , 1 , 3 , 3 , 1 , 9 , 9 , 4 , 1 , 1 , 1 } ; static const
real_T rtcapiStoredFloats [ ] = { 0.0 } ; static const rtwCAPI_FixPtMap
rtFixPtMap [ ] = { { ( NULL ) , ( NULL ) , rtwCAPI_FIX_RESERVED , 0 , 0 , 0 }
, } ; static const rtwCAPI_SampleTimeMap rtSampleTimeMap [ ] = { { ( const
void * ) & rtcapiStoredFloats [ 0 ] , ( const void * ) & rtcapiStoredFloats [
0 ] , 0 , 0 } } ; static rtwCAPI_ModelMappingStaticInfo mmiStatic = { {
rtBlockSignals , 7 , ( NULL ) , 0 , ( NULL ) , 0 } , { rtBlockParameters , 1
, rtModelParameters , 43 } , { ( NULL ) , 0 } , { rtDataTypeMap ,
rtDimensionMap , rtFixPtMap , rtElementMap , rtSampleTimeMap ,
rtDimensionArray } , "float" , { 4026905566U , 3233966698U , 2524878481U ,
3566277283U } , ( NULL ) , 0 , 0 } ; const rtwCAPI_ModelMappingStaticInfo *
sliding_car_GetCAPIStaticMap ( ) { return & mmiStatic ; }
#ifndef HOST_CAPI_BUILD
void sliding_car_InitializeDataMapInfo ( ) { rtwCAPI_SetVersion ( ( *
rt_dataMapInfoPtr ) . mmi , 1 ) ; rtwCAPI_SetStaticMap ( ( *
rt_dataMapInfoPtr ) . mmi , & mmiStatic ) ; rtwCAPI_SetLoggingStaticMap ( ( *
rt_dataMapInfoPtr ) . mmi , ( NULL ) ) ; rtwCAPI_SetDataAddressMap ( ( *
rt_dataMapInfoPtr ) . mmi , rtDataAddrMap ) ; rtwCAPI_SetVarDimsAddressMap (
( * rt_dataMapInfoPtr ) . mmi , rtVarDimsAddrMap ) ;
rtwCAPI_SetInstanceLoggingInfo ( ( * rt_dataMapInfoPtr ) . mmi , ( NULL ) ) ;
rtwCAPI_SetChildMMIArray ( ( * rt_dataMapInfoPtr ) . mmi , ( NULL ) ) ;
rtwCAPI_SetChildMMIArrayLen ( ( * rt_dataMapInfoPtr ) . mmi , 0 ) ; }
#else
#ifdef __cplusplus
extern "C" {
#endif
void sliding_car_host_InitializeDataMapInfo ( sliding_car_host_DataMapInfo_T
* dataMap , const char * path ) { rtwCAPI_SetVersion ( dataMap -> mmi , 1 ) ;
rtwCAPI_SetStaticMap ( dataMap -> mmi , & mmiStatic ) ;
rtwCAPI_SetDataAddressMap ( dataMap -> mmi , NULL ) ;
rtwCAPI_SetVarDimsAddressMap ( dataMap -> mmi , NULL ) ; rtwCAPI_SetPath (
dataMap -> mmi , path ) ; rtwCAPI_SetFullPath ( dataMap -> mmi , NULL ) ;
rtwCAPI_SetChildMMIArray ( dataMap -> mmi , ( NULL ) ) ;
rtwCAPI_SetChildMMIArrayLen ( dataMap -> mmi , 0 ) ; }
#ifdef __cplusplus
}
#endif
#endif
