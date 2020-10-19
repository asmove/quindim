#include "__cf_sliding_car.h"
#include "ext_types.h"
static uint_T rtDataTypeSizes [ ] = { sizeof ( real_T ) , sizeof ( real32_T )
, sizeof ( int8_T ) , sizeof ( uint8_T ) , sizeof ( int16_T ) , sizeof (
uint16_T ) , sizeof ( int32_T ) , sizeof ( uint32_T ) , sizeof ( boolean_T )
, sizeof ( fcn_call_T ) , sizeof ( int_T ) , sizeof ( pointer_T ) , sizeof (
action_T ) , 2 * sizeof ( uint32_T ) } ; static const char_T *
rtDataTypeNames [ ] = { "real_T" , "real32_T" , "int8_T" , "uint8_T" ,
"int16_T" , "uint16_T" , "int32_T" , "uint32_T" , "boolean_T" , "fcn_call_T"
, "int_T" , "pointer_T" , "action_T" , "timer_uint32_pair_T" } ; static
DataTypeTransition rtBTransitions [ ] = { { ( char_T * ) ( & rtB . hkbmt1bwgv
[ 0 ] ) , 0 , 0 , 27 } , { ( char_T * ) ( & rtB . lyhikfrpp3 . n01yyskxy4 [ 0
] ) , 0 , 0 , 81 } , { ( char_T * ) ( & rtB . fdaowiniar . n01yyskxy4 [ 0 ] )
, 0 , 0 , 81 } , { ( char_T * ) ( & rtDW . ftipop2ikq . LoggedData ) , 11 , 0
, 1 } } ; static DataTypeTransitionTable rtBTransTable = { 4U ,
rtBTransitions } ; static DataTypeTransition rtPTransitions [ ] = { { (
char_T * ) ( & rtP . Cp_1 ) , 0 , 0 , 58 } } ; static DataTypeTransitionTable
rtPTransTable = { 1U , rtPTransitions } ;
