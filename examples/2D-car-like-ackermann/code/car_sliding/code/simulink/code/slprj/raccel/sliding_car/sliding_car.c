#include "__cf_sliding_car.h"
#include "rt_logging_mmi.h"
#include "sliding_car_capi.h"
#include <math.h>
#include "sliding_car.h"
#include "sliding_car_private.h"
#include "sliding_car_dt.h"
extern void * CreateDiagnosticAsVoidPtr_wrapper ( const char * id , int nargs
, ... ) ; RTWExtModeInfo * gblRTWExtModeInfo = NULL ; extern boolean_T
gblExtModeStartPktReceived ; void raccelForceExtModeShutdown ( ) { if ( !
gblExtModeStartPktReceived ) { boolean_T stopRequested = false ;
rtExtModeWaitForStartPkt ( gblRTWExtModeInfo , 1 , & stopRequested ) ; }
rtExtModeShutdown ( 1 ) ; } const int_T gblNumToFiles = 0 ; const int_T
gblNumFrFiles = 0 ; const int_T gblNumFrWksBlocks = 0 ;
#ifdef RSIM_WITH_SOLVER_MULTITASKING
boolean_T gbl_raccel_isMultitasking = 1 ;
#else
boolean_T gbl_raccel_isMultitasking = 0 ;
#endif
boolean_T gbl_raccel_tid01eq = 0 ; int_T gbl_raccel_NumST = 2 ; const char_T
* gbl_raccel_Version = "8.9 (R2017a) 16-Feb-2017" ; void
raccel_setup_MMIStateLog ( SimStruct * S ) {
#ifdef UseMMIDataLogging
rt_FillStateSigInfoFromMMI ( ssGetRTWLogInfo ( S ) , & ssGetErrorStatus ( S )
) ;
#else
UNUSED_PARAMETER ( S ) ;
#endif
} static DataMapInfo rt_dataMapInfo ; DataMapInfo * rt_dataMapInfoPtr = &
rt_dataMapInfo ; rtwCAPI_ModelMappingInfo * rt_modelMapInfoPtr = & (
rt_dataMapInfo . mmi ) ; const char * gblSlvrJacPatternFileName =
"slprj//raccel//sliding_car//sliding_car_Jpattern.mat" ; const int_T
gblNumRootInportBlks = 0 ; const int_T gblNumModelInputs = 0 ; extern
rtInportTUtable * gblInportTUtables ; extern const char * gblInportFileName ;
const int_T gblInportDataTypeIdx [ ] = { - 1 } ; const int_T gblInportDims [
] = { - 1 } ; const int_T gblInportComplex [ ] = { - 1 } ; const int_T
gblInportInterpoFlag [ ] = { - 1 } ; const int_T gblInportContinuous [ ] = {
- 1 } ;
#include "simstruc.h"
#include "fixedpoint.h"
B rtB ; X rtX ; DW rtDW ; static SimStruct model_S ; SimStruct * const rtS =
& model_S ; static void myoj3mxfoz ( const real_T x [ 81 ] , real_T y [ 81 ]
) ; static boolean_T bh1hrlycek ( const real_T x [ 81 ] ) ; static real_T
ic0tlwsnxj ( int32_T n , const real_T x [ 81 ] , int32_T ix0 ) ; static void
emumoswdy1 ( int32_T m , int32_T n , real_T alpha1 , int32_T ix0 , const
real_T y [ 9 ] , real_T A [ 81 ] , int32_T ia0 ) ; static void jxwaug1pc5 (
real_T a [ 81 ] , real_T tau [ 8 ] ) ; static void ifpuw5fuda ( int32_T n ,
int32_T ilo , int32_T ihi , real_T A [ 81 ] , int32_T ia0 , const real_T tau
[ 8 ] , int32_T itau0 ) ; static real_T ic0tlwsnxjr ( int32_T n , const
real_T x [ 3 ] ) ; static real_T lmepxwkgik ( int32_T n , real_T * alpha1 ,
real_T x [ 3 ] ) ; static void bm3muqqiws ( real_T * a , real_T * b , real_T
* c , real_T * d , real_T * rt1r , real_T * rt1i , real_T * rt2r , real_T *
rt2i , real_T * cs , real_T * sn ) ; static void kuwozgrfuc ( int32_T n ,
real_T x [ 81 ] , int32_T ix0 , int32_T iy0 , real_T c , real_T s ) ; static
void kuwozgrfucf ( int32_T n , real_T x [ 81 ] , int32_T ix0 , int32_T iy0 ,
real_T c , real_T s ) ; static void kuwozgrfucfz ( real_T x [ 81 ] , int32_T
ix0 , int32_T iy0 , real_T c , real_T s ) ; static int32_T pb1lrny1as (
real_T h [ 81 ] , real_T z [ 81 ] ) ; static int32_T f3ikqo5yby ( real_T h [
81 ] , real_T z [ 81 ] ) ; static void oerr3d2lo0 ( const real_T Ur [ 81 ] ,
const real_T Tr [ 81 ] , creal_T U [ 81 ] , creal_T T [ 81 ] ) ; static void
d3jjyurfim ( creal_T x [ 81 ] ) ; static void idbbxhzzmc ( const real_T A [
81 ] , creal_T V [ 81 ] , creal_T T [ 81 ] ) ; static boolean_T jg3q0qpu5h (
const creal_T T [ 81 ] ) ; static void jflkbipdbe ( creal_T * x ) ; static
real_T ebbzxa51eo ( const real_T x [ 81 ] ) ; static void ks0umh2kvmx (
real_T a , real_T x [ 36 ] , int32_T ix0 ) ; static void gtjasxtio4 ( real_T
x [ 36 ] , int32_T ix0 , int32_T iy0 ) ; static void gtjasxtio45 ( real_T x [
54 ] , int32_T ix0 , int32_T iy0 ) ; static void odkxuqubc0 ( real_T * a ,
real_T * b , real_T * c , real_T * s ) ; static void ky0gbvlahv ( real_T x [
36 ] , int32_T ix0 , int32_T iy0 , real_T c , real_T s ) ; static void
ky0gbvlahv0 ( real_T x [ 54 ] , int32_T ix0 , int32_T iy0 , real_T c , real_T
s ) ; static void ks0umh2kvm ( real_T a , real_T x [ 54 ] , int32_T ix0 ) ;
static real_T pcua3j5c4dq ( int32_T n , const real_T x [ 36 ] , int32_T ix0 ,
const real_T y [ 36 ] , int32_T iy0 ) ; static void dyou0ajb1milt ( int32_T n
, real_T a , int32_T ix0 , real_T y [ 36 ] , int32_T iy0 ) ; static real_T
pcua3j5c4d ( int32_T n , const real_T x [ 54 ] , int32_T ix0 , const real_T y
[ 54 ] , int32_T iy0 ) ; static void dyou0ajb1m ( int32_T n , real_T a ,
int32_T ix0 , real_T y [ 54 ] , int32_T iy0 ) ; static real_T evonddxn2x (
int32_T n , const real_T x [ 54 ] , int32_T ix0 ) ; static real_T evonddxn2xs
( int32_T n , const real_T x [ 6 ] , int32_T ix0 ) ; static void dyou0ajb1mil
( int32_T n , real_T a , const real_T x [ 9 ] , int32_T ix0 , real_T y [ 54 ]
, int32_T iy0 ) ; static void dyou0ajb1mi ( int32_T n , real_T a , const
real_T x [ 54 ] , int32_T ix0 , real_T y [ 9 ] , int32_T iy0 ) ; static void
otuiewre2g ( const real_T A [ 54 ] , real_T U [ 54 ] , real_T s [ 6 ] ,
real_T V [ 36 ] ) ; static void myoj3mxfoz ( const real_T x [ 81 ] , real_T y
[ 81 ] ) { int8_T p [ 9 ] ; real_T A [ 81 ] ; int8_T ipiv [ 9 ] ; int32_T b_j
; real_T smax ; real_T s ; int32_T iy ; int32_T c_ix ; int32_T d ; int32_T
ijA ; int32_T jBcol ; int32_T kAcol ; int32_T c_i ; for ( b_j = 0 ; b_j < 81
; b_j ++ ) { y [ b_j ] = 0.0 ; A [ b_j ] = x [ b_j ] ; } for ( b_j = 0 ; b_j
< 9 ; b_j ++ ) { ipiv [ b_j ] = ( int8_T ) ( 1 + b_j ) ; } for ( b_j = 0 ;
b_j < 8 ; b_j ++ ) { jBcol = b_j * 10 ; iy = 0 ; kAcol = jBcol ; smax =
muDoubleScalarAbs ( A [ jBcol ] ) ; for ( c_i = 2 ; c_i <= 9 - b_j ; c_i ++ )
{ kAcol ++ ; s = muDoubleScalarAbs ( A [ kAcol ] ) ; if ( s > smax ) { iy =
c_i - 1 ; smax = s ; } } if ( A [ jBcol + iy ] != 0.0 ) { if ( iy != 0 ) {
ipiv [ b_j ] = ( int8_T ) ( ( b_j + iy ) + 1 ) ; kAcol = b_j ; iy += b_j ;
for ( c_i = 0 ; c_i < 9 ; c_i ++ ) { smax = A [ kAcol ] ; A [ kAcol ] = A [
iy ] ; A [ iy ] = smax ; kAcol += 9 ; iy += 9 ; } } iy = ( jBcol - b_j ) + 9
; for ( kAcol = jBcol + 1 ; kAcol + 1 <= iy ; kAcol ++ ) { A [ kAcol ] /= A [
jBcol ] ; } } iy = jBcol ; kAcol = jBcol + 9 ; for ( c_i = 1 ; c_i <= 8 - b_j
; c_i ++ ) { smax = A [ kAcol ] ; if ( A [ kAcol ] != 0.0 ) { c_ix = jBcol +
1 ; d = ( iy - b_j ) + 18 ; for ( ijA = 10 + iy ; ijA + 1 <= d ; ijA ++ ) { A
[ ijA ] += A [ c_ix ] * - smax ; c_ix ++ ; } } kAcol += 9 ; iy += 9 ; } } for
( b_j = 0 ; b_j < 9 ; b_j ++ ) { p [ b_j ] = ( int8_T ) ( 1 + b_j ) ; } for (
b_j = 0 ; b_j < 8 ; b_j ++ ) { if ( ipiv [ b_j ] > 1 + b_j ) { jBcol = p [
ipiv [ b_j ] - 1 ] ; p [ ipiv [ b_j ] - 1 ] = p [ b_j ] ; p [ b_j ] = (
int8_T ) jBcol ; } } for ( b_j = 0 ; b_j < 9 ; b_j ++ ) { jBcol = p [ b_j ] -
1 ; y [ b_j + 9 * ( p [ b_j ] - 1 ) ] = 1.0 ; for ( iy = b_j ; iy + 1 < 10 ;
iy ++ ) { if ( y [ 9 * jBcol + iy ] != 0.0 ) { for ( kAcol = iy + 1 ; kAcol +
1 < 10 ; kAcol ++ ) { y [ kAcol + 9 * jBcol ] -= y [ 9 * jBcol + iy ] * A [ 9
* iy + kAcol ] ; } } } } for ( b_j = 0 ; b_j < 9 ; b_j ++ ) { jBcol = 9 * b_j
; for ( iy = 8 ; iy >= 0 ; iy += - 1 ) { kAcol = 9 * iy ; if ( y [ iy + jBcol
] != 0.0 ) { y [ iy + jBcol ] /= A [ iy + kAcol ] ; for ( c_i = 0 ; c_i + 1
<= iy ; c_i ++ ) { y [ c_i + jBcol ] -= y [ iy + jBcol ] * A [ c_i + kAcol ]
; } } } } } void dxh5jlqdfh ( const real_T kz4ud1i3ym [ 81 ] , mnc2uupdn3 *
localB ) { myoj3mxfoz ( kz4ud1i3ym , localB -> n01yyskxy4 ) ; } static
boolean_T bh1hrlycek ( const real_T x [ 81 ] ) { boolean_T p ; int32_T k ; p
= false ; for ( k = 0 ; k < 81 ; k ++ ) { if ( p || muDoubleScalarIsInf ( x [
k ] ) || muDoubleScalarIsNaN ( x [ k ] ) ) { p = true ; } } return p ; }
static real_T ic0tlwsnxj ( int32_T n , const real_T x [ 81 ] , int32_T ix0 )
{ real_T y ; real_T scale ; int32_T kend ; real_T absxk ; real_T t ; int32_T
k ; y = 0.0 ; if ( ! ( n < 1 ) ) { if ( n == 1 ) { y = muDoubleScalarAbs ( x
[ ix0 - 1 ] ) ; } else { scale = 2.2250738585072014E-308 ; kend = ( ix0 + n )
- 1 ; for ( k = ix0 ; k <= kend ; k ++ ) { absxk = muDoubleScalarAbs ( x [ k
- 1 ] ) ; if ( absxk > scale ) { t = scale / absxk ; y = y * t * t + 1.0 ;
scale = absxk ; } else { t = absxk / scale ; y += t * t ; } } y = scale *
muDoubleScalarSqrt ( y ) ; } } return y ; } static void emumoswdy1 ( int32_T
m , int32_T n , real_T alpha1 , int32_T ix0 , const real_T y [ 9 ] , real_T A
[ 81 ] , int32_T ia0 ) { int32_T jA ; int32_T jy ; real_T temp ; int32_T ix ;
int32_T j ; int32_T b ; int32_T ijA ; if ( ! ( alpha1 == 0.0 ) ) { jA = ia0 -
1 ; jy = 0 ; for ( j = 1 ; j <= n ; j ++ ) { if ( y [ jy ] != 0.0 ) { temp =
y [ jy ] * alpha1 ; ix = ix0 ; b = m + jA ; for ( ijA = jA ; ijA + 1 <= b ;
ijA ++ ) { A [ ijA ] += A [ ix - 1 ] * temp ; ix ++ ; } } jy ++ ; jA += 9 ; }
} } static void jxwaug1pc5 ( real_T a [ 81 ] , real_T tau [ 8 ] ) { real_T
work [ 9 ] ; int32_T im1n ; int32_T in ; int32_T ia0 ; real_T alpha1 ;
int32_T i ; real_T xnorm ; int32_T knt ; int32_T rowleft ; int32_T ia ;
int32_T iy ; int32_T g ; int32_T b_ia ; int32_T jy ; real_T temp ; int32_T
b_ix ; int32_T exitg1 ; boolean_T exitg2 ; memset ( & work [ 0 ] , 0 , 9U *
sizeof ( real_T ) ) ; for ( i = 0 ; i < 8 ; i ++ ) { im1n = i * 9 + 2 ; in =
( i + 1 ) * 9 ; ia0 = i + 3 ; ia0 = muIntScalarMin_sint32 ( ia0 , 9 ) + i * 9
; alpha1 = a [ ( 9 * i + i ) + 1 ] ; temp = 0.0 ; xnorm = ic0tlwsnxj ( 7 - i
, a , ia0 ) ; if ( xnorm != 0.0 ) { xnorm = muDoubleScalarHypot ( a [ ( 9 * i
+ i ) + 1 ] , xnorm ) ; if ( a [ ( 9 * i + i ) + 1 ] >= 0.0 ) { xnorm = -
xnorm ; } if ( muDoubleScalarAbs ( xnorm ) < 1.0020841800044864E-292 ) { knt
= 0 ; do { knt ++ ; jy = ( ia0 - i ) + 6 ; for ( rowleft = ia0 ; rowleft <=
jy ; rowleft ++ ) { a [ rowleft - 1 ] *= 9.9792015476736E+291 ; } xnorm *=
9.9792015476736E+291 ; alpha1 *= 9.9792015476736E+291 ; } while ( ! (
muDoubleScalarAbs ( xnorm ) >= 1.0020841800044864E-292 ) ) ; xnorm =
muDoubleScalarHypot ( alpha1 , ic0tlwsnxj ( 7 - i , a , ia0 ) ) ; if ( alpha1
>= 0.0 ) { xnorm = - xnorm ; } temp = ( xnorm - alpha1 ) / xnorm ; alpha1 =
1.0 / ( alpha1 - xnorm ) ; jy = ( ia0 - i ) + 6 ; while ( ia0 <= jy ) { a [
ia0 - 1 ] *= alpha1 ; ia0 ++ ; } for ( ia0 = 1 ; ia0 <= knt ; ia0 ++ ) {
xnorm *= 1.0020841800044864E-292 ; } alpha1 = xnorm ; } else { temp = ( xnorm
- a [ ( 9 * i + i ) + 1 ] ) / xnorm ; alpha1 = 1.0 / ( a [ ( 9 * i + i ) + 1
] - xnorm ) ; knt = ( ia0 - i ) + 6 ; while ( ia0 <= knt ) { a [ ia0 - 1 ] *=
alpha1 ; ia0 ++ ; } alpha1 = xnorm ; } } tau [ i ] = temp ; a [ ( i + 9 * i )
+ 1 ] = 1.0 ; jy = ( i + im1n ) - 1 ; if ( tau [ i ] != 0.0 ) { knt = 8 - i ;
ia0 = ( jy - i ) + 7 ; while ( ( knt > 0 ) && ( a [ ia0 ] == 0.0 ) ) { knt --
; ia0 -- ; } ia0 = 9 ; exitg2 = false ; while ( ( ! exitg2 ) && ( ia0 > 0 ) )
{ rowleft = in + ia0 ; ia = rowleft ; do { exitg1 = 0 ; if ( ia <= ( knt - 1
) * 9 + rowleft ) { if ( a [ ia - 1 ] != 0.0 ) { exitg1 = 1 ; } else { ia +=
9 ; } } else { ia0 -- ; exitg1 = 2 ; } } while ( exitg1 == 0 ) ; if ( exitg1
== 1 ) { exitg2 = true ; } } } else { knt = 0 ; ia0 = 0 ; } if ( knt > 0 ) {
if ( ia0 != 0 ) { for ( rowleft = 1 ; rowleft <= ia0 ; rowleft ++ ) { work [
rowleft - 1 ] = 0.0 ; } rowleft = jy ; ia = ( ( knt - 1 ) * 9 + in ) + 1 ;
for ( b_ix = in + 1 ; b_ix <= ia ; b_ix += 9 ) { iy = 0 ; g = ( b_ix + ia0 )
- 1 ; for ( b_ia = b_ix ; b_ia <= g ; b_ia ++ ) { work [ iy ] += a [ b_ia - 1
] * a [ rowleft ] ; iy ++ ; } rowleft ++ ; } } if ( ! ( - tau [ i ] == 0.0 )
) { rowleft = in ; for ( ia = 1 ; ia <= knt ; ia ++ ) { if ( a [ jy ] != 0.0
) { temp = a [ jy ] * - tau [ i ] ; b_ix = 0 ; iy = ia0 + rowleft ; for ( g =
rowleft ; g + 1 <= iy ; g ++ ) { a [ g ] += work [ b_ix ] * temp ; b_ix ++ ;
} } jy ++ ; rowleft += 9 ; } } } im1n += i ; in = ( i + in ) + 2 ; if ( tau [
i ] != 0.0 ) { knt = 8 - i ; ia0 = ( im1n - i ) + 6 ; while ( ( knt > 0 ) &&
( a [ ia0 ] == 0.0 ) ) { knt -- ; ia0 -- ; } ia0 = 8 - i ; exitg2 = false ;
while ( ( ! exitg2 ) && ( ia0 > 0 ) ) { jy = ( ia0 - 1 ) * 9 + in ; rowleft =
jy ; do { exitg1 = 0 ; if ( rowleft <= ( jy + knt ) - 1 ) { if ( a [ rowleft
- 1 ] != 0.0 ) { exitg1 = 1 ; } else { rowleft ++ ; } } else { ia0 -- ;
exitg1 = 2 ; } } while ( exitg1 == 0 ) ; if ( exitg1 == 1 ) { exitg2 = true ;
} } } else { knt = 0 ; ia0 = 0 ; } if ( knt > 0 ) { if ( ia0 != 0 ) { for (
jy = 1 ; jy <= ia0 ; jy ++ ) { work [ jy - 1 ] = 0.0 ; } jy = 0 ; rowleft = (
ia0 - 1 ) * 9 + in ; for ( ia = in ; ia <= rowleft ; ia += 9 ) { b_ix = im1n
; temp = 0.0 ; iy = ( ia + knt ) - 1 ; for ( g = ia ; g <= iy ; g ++ ) { temp
+= a [ g - 1 ] * a [ b_ix - 1 ] ; b_ix ++ ; } work [ jy ] += temp ; jy ++ ; }
} emumoswdy1 ( knt , ia0 , - tau [ i ] , im1n , work , a , in ) ; } a [ ( i +
9 * i ) + 1 ] = alpha1 ; } } static void ifpuw5fuda ( int32_T n , int32_T ilo
, int32_T ihi , real_T A [ 81 ] , int32_T ia0 , const real_T tau [ 8 ] ,
int32_T itau0 ) { int32_T nh ; int32_T ia ; int32_T f_i ; int32_T itau ;
real_T work [ 9 ] ; int32_T iaii ; int32_T lastv ; int32_T lastc ; int32_T
coltop ; int32_T c_ia ; int32_T ix ; real_T b_c ; int32_T iac ; int32_T d ;
int32_T d_ia ; int32_T exitg1 ; boolean_T exitg2 ; if ( n != 0 ) { nh = ihi -
ilo ; for ( itau = ihi ; itau >= ilo + 1 ; itau -- ) { ia = ( ( itau - 1 ) *
9 + ia0 ) - 2 ; for ( f_i = 1 ; f_i < itau ; f_i ++ ) { A [ ia + f_i ] = 0.0
; } for ( f_i = itau + 1 ; f_i <= ihi ; f_i ++ ) { A [ ia + f_i ] = A [ ( ia
+ f_i ) - 9 ] ; } for ( f_i = ihi + 1 ; f_i <= n ; f_i ++ ) { A [ ia + f_i ]
= 0.0 ; } } for ( itau = 0 ; itau + 1 <= ilo ; itau ++ ) { ia = ( itau * 9 +
ia0 ) - 1 ; for ( f_i = 1 ; f_i <= n ; f_i ++ ) { A [ ( ia + f_i ) - 1 ] =
0.0 ; } A [ ia + itau ] = 1.0 ; } for ( itau = ihi ; itau + 1 <= n ; itau ++
) { ia = ( itau * 9 + ia0 ) - 1 ; for ( f_i = 1 ; f_i <= n ; f_i ++ ) { A [ (
ia + f_i ) - 1 ] = 0.0 ; } A [ ia + itau ] = 1.0 ; } ia = ( ia0 + ilo ) + ilo
* 9 ; if ( ! ( nh < 1 ) ) { for ( itau = nh ; itau < nh ; itau ++ ) { f_i =
itau * 9 + ia ; for ( iaii = 0 ; iaii < nh ; iaii ++ ) { A [ ( f_i + iaii ) -
1 ] = 0.0 ; } A [ ( f_i + itau ) - 1 ] = 1.0 ; } itau = ( ( itau0 + ilo ) +
nh ) - 3 ; memset ( & work [ 0 ] , 0 , 9U * sizeof ( real_T ) ) ; for ( f_i =
nh ; f_i >= 1 ; f_i -- ) { iaii = ( ( ( f_i - 1 ) * 9 + ia ) + f_i ) - 1 ; if
( f_i < nh ) { A [ iaii - 1 ] = 1.0 ; lastv = ( nh - f_i ) + 1 ; if ( tau [
itau ] != 0.0 ) { lastc = iaii + lastv ; while ( ( lastv > 0 ) && ( A [ lastc
- 2 ] == 0.0 ) ) { lastv -- ; lastc -- ; } lastc = nh - f_i ; exitg2 = false
; while ( ( ! exitg2 ) && ( lastc > 0 ) ) { coltop = ( ( lastc - 1 ) * 9 +
iaii ) + 9 ; c_ia = coltop ; do { exitg1 = 0 ; if ( c_ia <= ( coltop + lastv
) - 1 ) { if ( A [ c_ia - 1 ] != 0.0 ) { exitg1 = 1 ; } else { c_ia ++ ; } }
else { lastc -- ; exitg1 = 2 ; } } while ( exitg1 == 0 ) ; if ( exitg1 == 1 )
{ exitg2 = true ; } } } else { lastv = 0 ; lastc = 0 ; } if ( lastv > 0 ) {
if ( lastc != 0 ) { for ( coltop = 1 ; coltop <= lastc ; coltop ++ ) { work [
coltop - 1 ] = 0.0 ; } coltop = 0 ; c_ia = ( ( lastc - 1 ) * 9 + iaii ) + 9 ;
for ( iac = iaii + 9 ; iac <= c_ia ; iac += 9 ) { ix = iaii ; b_c = 0.0 ; d =
( iac + lastv ) - 1 ; for ( d_ia = iac ; d_ia <= d ; d_ia ++ ) { b_c += A [
d_ia - 1 ] * A [ ix - 1 ] ; ix ++ ; } work [ coltop ] += b_c ; coltop ++ ; }
} emumoswdy1 ( lastv , lastc , - tau [ itau ] , iaii , work , A , iaii + 9 )
; } lastv = ( iaii + nh ) - f_i ; for ( lastc = iaii ; lastc + 1 <= lastv ;
lastc ++ ) { A [ lastc ] *= - tau [ itau ] ; } } A [ iaii - 1 ] = 1.0 - tau [
itau ] ; for ( lastv = 1 ; lastv < f_i ; lastv ++ ) { A [ ( iaii - lastv ) -
1 ] = 0.0 ; } itau -- ; } } } } static real_T ic0tlwsnxjr ( int32_T n , const
real_T x [ 3 ] ) { real_T y ; real_T scale ; real_T absxk ; real_T t ;
int32_T k ; y = 0.0 ; if ( ! ( n < 1 ) ) { if ( n == 1 ) { y =
muDoubleScalarAbs ( x [ 1 ] ) ; } else { scale = 2.2250738585072014E-308 ;
for ( k = 2 ; k <= n + 1 ; k ++ ) { absxk = muDoubleScalarAbs ( x [ k - 1 ] )
; if ( absxk > scale ) { t = scale / absxk ; y = y * t * t + 1.0 ; scale =
absxk ; } else { t = absxk / scale ; y += t * t ; } } y = scale *
muDoubleScalarSqrt ( y ) ; } } return y ; } static real_T lmepxwkgik (
int32_T n , real_T * alpha1 , real_T x [ 3 ] ) { real_T tau ; real_T xnorm ;
int32_T knt ; int32_T c_k ; tau = 0.0 ; if ( ! ( n <= 0 ) ) { xnorm =
ic0tlwsnxjr ( n - 1 , x ) ; if ( xnorm != 0.0 ) { xnorm = muDoubleScalarHypot
( * alpha1 , xnorm ) ; if ( * alpha1 >= 0.0 ) { xnorm = - xnorm ; } if (
muDoubleScalarAbs ( xnorm ) < 1.0020841800044864E-292 ) { knt = 0 ; do { knt
++ ; for ( c_k = 1 ; c_k + 1 <= n ; c_k ++ ) { x [ c_k ] *=
9.9792015476736E+291 ; } xnorm *= 9.9792015476736E+291 ; * alpha1 *=
9.9792015476736E+291 ; } while ( ! ( muDoubleScalarAbs ( xnorm ) >=
1.0020841800044864E-292 ) ) ; xnorm = muDoubleScalarHypot ( * alpha1 ,
ic0tlwsnxjr ( n - 1 , x ) ) ; if ( * alpha1 >= 0.0 ) { xnorm = - xnorm ; }
tau = ( xnorm - * alpha1 ) / xnorm ; * alpha1 = 1.0 / ( * alpha1 - xnorm ) ;
for ( c_k = 1 ; c_k + 1 <= n ; c_k ++ ) { x [ c_k ] *= * alpha1 ; } for ( c_k
= 1 ; c_k <= knt ; c_k ++ ) { xnorm *= 1.0020841800044864E-292 ; } * alpha1 =
xnorm ; } else { tau = ( xnorm - * alpha1 ) / xnorm ; * alpha1 = 1.0 / ( *
alpha1 - xnorm ) ; for ( knt = 1 ; knt + 1 <= n ; knt ++ ) { x [ knt ] *= *
alpha1 ; } * alpha1 = xnorm ; } } } return tau ; } static void bm3muqqiws (
real_T * a , real_T * b , real_T * c , real_T * d , real_T * rt1r , real_T *
rt1i , real_T * rt2r , real_T * rt2i , real_T * cs , real_T * sn ) { real_T
temp ; real_T p ; real_T bcmax ; real_T bcmis ; real_T scale ; real_T z ;
int32_T b_p ; int32_T c_p ; if ( * c == 0.0 ) { * cs = 1.0 ; * sn = 0.0 ; }
else if ( * b == 0.0 ) { * cs = 0.0 ; * sn = 1.0 ; temp = * d ; * d = * a ; *
a = temp ; * b = - * c ; * c = 0.0 ; } else if ( ( * a - * d == 0.0 ) && ( (
* b < 0.0 ) != ( * c < 0.0 ) ) ) { * cs = 1.0 ; * sn = 0.0 ; } else { temp =
* a - * d ; p = 0.5 * temp ; bcmax = muDoubleScalarMax ( muDoubleScalarAbs (
* b ) , muDoubleScalarAbs ( * c ) ) ; if ( ! ( * b < 0.0 ) ) { b_p = 1 ; }
else { b_p = - 1 ; } if ( ! ( * c < 0.0 ) ) { c_p = 1 ; } else { c_p = - 1 ;
} bcmis = muDoubleScalarMin ( muDoubleScalarAbs ( * b ) , muDoubleScalarAbs (
* c ) ) * ( real_T ) b_p * ( real_T ) c_p ; scale = muDoubleScalarMax (
muDoubleScalarAbs ( p ) , bcmax ) ; z = p / scale * p + bcmax / scale * bcmis
; if ( z >= 8.8817841970012523E-16 ) { if ( ! ( p < 0.0 ) ) { temp =
muDoubleScalarSqrt ( scale ) * muDoubleScalarSqrt ( z ) ; } else { temp = - (
muDoubleScalarSqrt ( scale ) * muDoubleScalarSqrt ( z ) ) ; } z = p + temp ;
* a = * d + z ; * d -= bcmax / z * bcmis ; bcmax = muDoubleScalarHypot ( * c
, z ) ; * cs = z / bcmax ; * sn = * c / bcmax ; * b -= * c ; * c = 0.0 ; }
else { bcmis = * b + * c ; bcmax = muDoubleScalarHypot ( bcmis , temp ) ; *
cs = muDoubleScalarSqrt ( ( muDoubleScalarAbs ( bcmis ) / bcmax + 1.0 ) * 0.5
) ; if ( ! ( bcmis < 0.0 ) ) { b_p = 1 ; } else { b_p = - 1 ; } * sn = - ( p
/ ( bcmax * * cs ) ) * ( real_T ) b_p ; temp = * a * * cs + * b * * sn ; p =
- * a * * sn + * b * * cs ; bcmax = * c * * cs + * d * * sn ; bcmis = - * c *
* sn + * d * * cs ; * b = p * * cs + bcmis * * sn ; * c = - temp * * sn +
bcmax * * cs ; temp = ( ( temp * * cs + bcmax * * sn ) + ( - p * * sn + bcmis
* * cs ) ) * 0.5 ; * a = temp ; * d = temp ; if ( * c != 0.0 ) { if ( * b !=
0.0 ) { if ( ( * b < 0.0 ) == ( * c < 0.0 ) ) { z = muDoubleScalarSqrt (
muDoubleScalarAbs ( * b ) ) ; bcmis = muDoubleScalarSqrt ( muDoubleScalarAbs
( * c ) ) ; p = z * bcmis ; if ( * c < 0.0 ) { p = - p ; } bcmax = 1.0 /
muDoubleScalarSqrt ( muDoubleScalarAbs ( * b + * c ) ) ; * a = temp + p ; * d
= temp - p ; * b -= * c ; * c = 0.0 ; p = z * bcmax ; bcmax *= bcmis ; temp =
* cs * p - * sn * bcmax ; * sn = * cs * bcmax + * sn * p ; * cs = temp ; } }
else { * b = - * c ; * c = 0.0 ; temp = * cs ; * cs = - * sn ; * sn = temp ;
} } } } * rt1r = * a ; * rt2r = * d ; if ( * c == 0.0 ) { * rt1i = 0.0 ; *
rt2i = 0.0 ; } else { * rt1i = muDoubleScalarSqrt ( muDoubleScalarAbs ( * b )
) * muDoubleScalarSqrt ( muDoubleScalarAbs ( * c ) ) ; * rt2i = - * rt1i ; }
} static void kuwozgrfuc ( int32_T n , real_T x [ 81 ] , int32_T ix0 ,
int32_T iy0 , real_T c , real_T s ) { int32_T ix ; int32_T iy ; real_T temp ;
int32_T k ; if ( ! ( n < 1 ) ) { ix = ix0 - 1 ; iy = iy0 - 1 ; for ( k = 1 ;
k <= n ; k ++ ) { temp = c * x [ ix ] + s * x [ iy ] ; x [ iy ] = c * x [ iy
] - s * x [ ix ] ; x [ ix ] = temp ; iy += 9 ; ix += 9 ; } } } static void
kuwozgrfucf ( int32_T n , real_T x [ 81 ] , int32_T ix0 , int32_T iy0 ,
real_T c , real_T s ) { int32_T ix ; int32_T iy ; real_T temp ; int32_T k ;
if ( ! ( n < 1 ) ) { ix = ix0 - 1 ; iy = iy0 - 1 ; for ( k = 1 ; k <= n ; k
++ ) { temp = c * x [ ix ] + s * x [ iy ] ; x [ iy ] = c * x [ iy ] - s * x [
ix ] ; x [ ix ] = temp ; iy ++ ; ix ++ ; } } } static void kuwozgrfucfz (
real_T x [ 81 ] , int32_T ix0 , int32_T iy0 , real_T c , real_T s ) { int32_T
ix ; int32_T iy ; real_T temp ; int32_T k ; ix = ix0 - 1 ; iy = iy0 - 1 ; for
( k = 0 ; k < 9 ; k ++ ) { temp = c * x [ ix ] + s * x [ iy ] ; x [ iy ] = c
* x [ iy ] - s * x [ ix ] ; x [ ix ] = temp ; iy ++ ; ix ++ ; } } static
int32_T pb1lrny1as ( real_T h [ 81 ] , real_T z [ 81 ] ) { int32_T info ;
real_T v [ 3 ] ; int32_T i ; int32_T L ; boolean_T goto150 ; int32_T k ;
real_T tst ; real_T htmp1 ; real_T ab ; real_T ba ; real_T aa ; real_T h12 ;
int32_T m ; int32_T nr ; int32_T hoffset ; real_T cs ; real_T sn ; real_T b_v
[ 3 ] ; int32_T its ; int32_T b_k ; int32_T b_j ; real_T b_y ; real_T c_y ;
boolean_T exitg1 ; boolean_T exitg2 ; boolean_T exitg3 ; info = 0 ; for ( i =
0 ; i < 6 ; i ++ ) { h [ ( i + 9 * i ) + 2 ] = 0.0 ; h [ ( i + 9 * i ) + 3 ]
= 0.0 ; } h [ 62 ] = 0.0 ; i = 8 ; exitg1 = false ; while ( ( ! exitg1 ) && (
i + 1 >= 1 ) ) { L = 1 ; goto150 = false ; its = 0 ; exitg2 = false ; while (
( ! exitg2 ) && ( its < 31 ) ) { k = i ; exitg3 = false ; while ( ( ! exitg3
) && ( ( k + 1 > L ) && ( ! ( muDoubleScalarAbs ( h [ ( k - 1 ) * 9 + k ] )
<= 9.0187576200403775E-292 ) ) ) ) { tst = muDoubleScalarAbs ( h [ ( ( k - 1
) * 9 + k ) - 1 ] ) + muDoubleScalarAbs ( h [ 9 * k + k ] ) ; if ( tst == 0.0
) { if ( k - 1 >= 1 ) { tst = muDoubleScalarAbs ( h [ ( ( k - 2 ) * 9 + k ) -
1 ] ) ; } if ( k + 2 <= 9 ) { tst += muDoubleScalarAbs ( h [ ( 9 * k + k ) +
1 ] ) ; } } if ( muDoubleScalarAbs ( h [ ( k - 1 ) * 9 + k ] ) <=
2.2204460492503131E-16 * tst ) { htmp1 = muDoubleScalarAbs ( h [ ( k - 1 ) *
9 + k ] ) ; tst = muDoubleScalarAbs ( h [ ( 9 * k + k ) - 1 ] ) ; if ( htmp1
> tst ) { ab = htmp1 ; ba = tst ; } else { ab = tst ; ba = htmp1 ; } htmp1 =
muDoubleScalarAbs ( h [ 9 * k + k ] ) ; tst = muDoubleScalarAbs ( h [ ( ( k -
1 ) * 9 + k ) - 1 ] - h [ 9 * k + k ] ) ; if ( htmp1 > tst ) { aa = htmp1 ;
htmp1 = tst ; } else { aa = tst ; } tst = aa + ab ; if ( ab / tst * ba <=
muDoubleScalarMax ( 9.0187576200403775E-292 , aa / tst * htmp1 *
2.2204460492503131E-16 ) ) { exitg3 = true ; } else { k -- ; } } else { k --
; } } L = k + 1 ; if ( k + 1 > 1 ) { h [ k + 9 * ( k - 1 ) ] = 0.0 ; } if ( k
+ 1 >= i ) { goto150 = true ; exitg2 = true ; } else { if ( its == 10 ) { tst
= muDoubleScalarAbs ( h [ ( ( k + 1 ) * 9 + k ) + 2 ] ) + muDoubleScalarAbs (
h [ ( 9 * k + k ) + 1 ] ) ; htmp1 = h [ 9 * k + k ] + 0.75 * tst ; h12 = -
0.4375 * tst ; aa = tst ; ba = htmp1 ; } else if ( its == 20 ) { tst =
muDoubleScalarAbs ( h [ ( ( i - 2 ) * 9 + i ) - 1 ] ) + muDoubleScalarAbs ( h
[ ( i - 1 ) * 9 + i ] ) ; htmp1 = h [ 9 * i + i ] + 0.75 * tst ; h12 = -
0.4375 * tst ; aa = tst ; ba = htmp1 ; } else { htmp1 = h [ ( ( i - 1 ) * 9 +
i ) - 1 ] ; aa = h [ ( i - 1 ) * 9 + i ] ; h12 = h [ ( 9 * i + i ) - 1 ] ; ba
= h [ 9 * i + i ] ; } tst = ( ( muDoubleScalarAbs ( htmp1 ) +
muDoubleScalarAbs ( h12 ) ) + muDoubleScalarAbs ( aa ) ) + muDoubleScalarAbs
( ba ) ; if ( tst == 0.0 ) { htmp1 = 0.0 ; ba = 0.0 ; ab = 0.0 ; aa = 0.0 ; }
else { htmp1 /= tst ; aa /= tst ; h12 /= tst ; ba /= tst ; ab = ( htmp1 + ba
) / 2.0 ; htmp1 = ( htmp1 - ab ) * ( ba - ab ) - h12 * aa ; aa =
muDoubleScalarSqrt ( muDoubleScalarAbs ( htmp1 ) ) ; if ( htmp1 >= 0.0 ) {
htmp1 = ab * tst ; ab = htmp1 ; ba = aa * tst ; aa = - ba ; } else { htmp1 =
ab + aa ; ab -= aa ; if ( muDoubleScalarAbs ( htmp1 - ba ) <=
muDoubleScalarAbs ( ab - ba ) ) { htmp1 *= tst ; ab = htmp1 ; } else { ab *=
tst ; htmp1 = ab ; } ba = 0.0 ; aa = 0.0 ; } } m = i - 1 ; exitg3 = false ;
while ( ( ! exitg3 ) && ( m >= k + 1 ) ) { tst = ( muDoubleScalarAbs ( h [ (
( m - 1 ) * 9 + m ) - 1 ] - ab ) + muDoubleScalarAbs ( aa ) ) +
muDoubleScalarAbs ( h [ ( m - 1 ) * 9 + m ] ) ; h12 = h [ ( m - 1 ) * 9 + m ]
/ tst ; v [ 0 ] = ( ( h [ ( ( m - 1 ) * 9 + m ) - 1 ] - ab ) / tst * ( h [ (
( m - 1 ) * 9 + m ) - 1 ] - htmp1 ) + h [ ( 9 * m + m ) - 1 ] * h12 ) - aa /
tst * ba ; v [ 1 ] = ( ( ( h [ ( ( m - 1 ) * 9 + m ) - 1 ] + h [ 9 * m + m ]
) - htmp1 ) - ab ) * h12 ; v [ 2 ] = h [ ( 9 * m + m ) + 1 ] * h12 ; tst = (
muDoubleScalarAbs ( v [ 0 ] ) + muDoubleScalarAbs ( v [ 1 ] ) ) +
muDoubleScalarAbs ( v [ 2 ] ) ; h12 = v [ 0 ] / tst ; v [ 0 ] /= tst ; b_y =
v [ 1 ] / tst ; v [ 1 ] /= tst ; c_y = v [ 2 ] / tst ; v [ 2 ] /= tst ; if (
( k + 1 == m ) || ( muDoubleScalarAbs ( h [ ( ( m - 2 ) * 9 + m ) - 1 ] ) * (
muDoubleScalarAbs ( b_y ) + muDoubleScalarAbs ( c_y ) ) <= ( (
muDoubleScalarAbs ( h [ ( ( m - 2 ) * 9 + m ) - 2 ] ) + muDoubleScalarAbs ( h
[ ( ( m - 1 ) * 9 + m ) - 1 ] ) ) + muDoubleScalarAbs ( h [ 9 * m + m ] ) ) *
( 2.2204460492503131E-16 * muDoubleScalarAbs ( h12 ) ) ) ) { exitg3 = true ;
} else { m -- ; } } for ( b_k = m ; b_k <= i ; b_k ++ ) { nr = ( i - b_k ) +
2 ; nr = muIntScalarMin_sint32 ( 3 , nr ) ; if ( b_k > m ) { hoffset = ( b_k
- 2 ) * 9 + b_k ; for ( b_j = - 1 ; b_j + 2 <= nr ; b_j ++ ) { v [ b_j + 1 ]
= h [ b_j + hoffset ] ; } } htmp1 = v [ 0 ] ; b_v [ 0 ] = v [ 0 ] ; b_v [ 1 ]
= v [ 1 ] ; b_v [ 2 ] = v [ 2 ] ; tst = lmepxwkgik ( nr , & htmp1 , b_v ) ; v
[ 1 ] = b_v [ 1 ] ; v [ 2 ] = b_v [ 2 ] ; v [ 0 ] = htmp1 ; if ( b_k > m ) {
h [ ( b_k + 9 * ( b_k - 2 ) ) - 1 ] = htmp1 ; h [ b_k + 9 * ( b_k - 2 ) ] =
0.0 ; if ( b_k < i ) { h [ ( b_k + 9 * ( b_k - 2 ) ) + 1 ] = 0.0 ; } } else {
if ( m > k + 1 ) { h [ ( b_k + 9 * ( b_k - 2 ) ) - 1 ] *= 1.0 - tst ; } }
htmp1 = b_v [ 1 ] ; ab = tst * b_v [ 1 ] ; if ( nr == 3 ) { aa = b_v [ 2 ] ;
h12 = tst * b_v [ 2 ] ; for ( nr = b_k - 1 ; nr + 1 < 10 ; nr ++ ) { ba = ( h
[ ( 9 * nr + b_k ) - 1 ] + h [ 9 * nr + b_k ] * htmp1 ) + h [ ( 9 * nr + b_k
) + 1 ] * aa ; h [ ( b_k + 9 * nr ) - 1 ] -= ba * tst ; h [ b_k + 9 * nr ] -=
ba * ab ; h [ ( b_k + 9 * nr ) + 1 ] -= ba * h12 ; } nr = b_k + 3 ; hoffset =
i + 1 ; nr = muIntScalarMin_sint32 ( nr , hoffset ) ; for ( hoffset = 0 ;
hoffset + 1 <= nr ; hoffset ++ ) { ba = ( h [ ( b_k - 1 ) * 9 + hoffset ] + h
[ 9 * b_k + hoffset ] * htmp1 ) + h [ ( b_k + 1 ) * 9 + hoffset ] * aa ; h [
hoffset + 9 * ( b_k - 1 ) ] -= ba * tst ; h [ hoffset + 9 * b_k ] -= ba * ab
; h [ hoffset + 9 * ( b_k + 1 ) ] -= ba * h12 ; } for ( nr = 0 ; nr < 9 ; nr
++ ) { ba = ( z [ ( b_k - 1 ) * 9 + nr ] + z [ 9 * b_k + nr ] * htmp1 ) + z [
( b_k + 1 ) * 9 + nr ] * aa ; z [ nr + 9 * ( b_k - 1 ) ] -= ba * tst ; z [ nr
+ 9 * b_k ] -= ba * ab ; z [ nr + 9 * ( b_k + 1 ) ] -= ba * h12 ; } } else {
if ( nr == 2 ) { for ( nr = b_k - 1 ; nr + 1 < 10 ; nr ++ ) { ba = h [ ( 9 *
nr + b_k ) - 1 ] + h [ 9 * nr + b_k ] * htmp1 ; h [ ( b_k + 9 * nr ) - 1 ] -=
ba * tst ; h [ b_k + 9 * nr ] -= ba * ab ; } for ( nr = 0 ; nr + 1 <= i + 1 ;
nr ++ ) { ba = h [ ( b_k - 1 ) * 9 + nr ] + h [ 9 * b_k + nr ] * htmp1 ; h [
nr + 9 * ( b_k - 1 ) ] -= ba * tst ; h [ nr + 9 * b_k ] -= ba * ab ; } for (
nr = 0 ; nr < 9 ; nr ++ ) { ba = z [ ( b_k - 1 ) * 9 + nr ] + z [ 9 * b_k +
nr ] * htmp1 ; z [ nr + 9 * ( b_k - 1 ) ] -= ba * tst ; z [ nr + 9 * b_k ] -=
ba * ab ; } } } } its ++ ; } } if ( ! goto150 ) { info = i + 1 ; exitg1 =
true ; } else { if ( ! ( ( i + 1 == L ) || ( ! ( L == i ) ) ) ) { tst = h [ (
( i - 1 ) * 9 + i ) - 1 ] ; htmp1 = h [ ( 9 * i + i ) - 1 ] ; ab = h [ ( i -
1 ) * 9 + i ] ; ba = h [ 9 * i + i ] ; bm3muqqiws ( & tst , & htmp1 , & ab ,
& ba , & aa , & h12 , & b_y , & c_y , & cs , & sn ) ; h [ ( i + 9 * ( i - 1 )
) - 1 ] = tst ; h [ ( i + 9 * i ) - 1 ] = htmp1 ; h [ i + 9 * ( i - 1 ) ] =
ab ; h [ i + 9 * i ] = ba ; if ( 9 > i + 1 ) { kuwozgrfuc ( 8 - i , h , i + (
i + 1 ) * 9 , ( i + ( i + 1 ) * 9 ) + 1 , cs , sn ) ; } kuwozgrfucf ( i - 1 ,
h , 1 + ( i - 1 ) * 9 , 1 + i * 9 , cs , sn ) ; kuwozgrfucfz ( z , 1 + ( i -
1 ) * 9 , 1 + i * 9 , cs , sn ) ; } i = L - 2 ; } } return info ; } static
int32_T f3ikqo5yby ( real_T h [ 81 ] , real_T z [ 81 ] ) { int32_T info ;
int32_T istart ; int32_T j ; int32_T i ; info = pb1lrny1as ( h , z ) ; istart
= 4 ; for ( j = 0 ; j < 6 ; j ++ ) { for ( i = istart ; i < 10 ; i ++ ) { h [
( i + 9 * j ) - 1 ] = 0.0 ; } istart ++ ; } return info ; } static void
oerr3d2lo0 ( const real_T Ur [ 81 ] , const real_T Tr [ 81 ] , creal_T U [ 81
] , creal_T T [ 81 ] ) { int32_T m ; real_T r ; int32_T j ; real_T rt1r ;
real_T rt2r ; real_T rt2i ; real_T cs ; real_T sn ; real_T mu1_re ; real_T
mu1_im ; real_T t1_re ; real_T t1_im ; for ( m = 0 ; m < 81 ; m ++ ) { T [ m
] . re = Tr [ m ] ; T [ m ] . im = 0.0 ; U [ m ] . re = Ur [ m ] ; U [ m ] .
im = 0.0 ; } for ( m = 7 ; m >= 0 ; m += - 1 ) { if ( Tr [ ( 9 * m + m ) + 1
] != 0.0 ) { r = Tr [ 9 * m + m ] ; mu1_re = Tr [ ( m + 1 ) * 9 + m ] ; t1_re
= Tr [ ( 9 * m + m ) + 1 ] ; t1_im = Tr [ ( ( m + 1 ) * 9 + m ) + 1 ] ;
bm3muqqiws ( & r , & mu1_re , & t1_re , & t1_im , & rt1r , & mu1_im , & rt2r
, & rt2i , & cs , & sn ) ; mu1_re = rt1r - Tr [ ( ( m + 1 ) * 9 + m ) + 1 ] ;
r = muDoubleScalarHypot ( muDoubleScalarHypot ( mu1_re , mu1_im ) , Tr [ ( 9
* m + m ) + 1 ] ) ; if ( mu1_im == 0.0 ) { mu1_re /= r ; mu1_im = 0.0 ; }
else if ( mu1_re == 0.0 ) { mu1_re = 0.0 ; mu1_im /= r ; } else { mu1_re /= r
; mu1_im /= r ; } r = Tr [ ( 9 * m + m ) + 1 ] / r ; for ( j = m ; j + 1 < 10
; j ++ ) { t1_re = T [ 9 * j + m ] . re ; t1_im = T [ 9 * j + m ] . im ; rt1r
= T [ 9 * j + m ] . re ; T [ m + 9 * j ] . re = ( T [ 9 * j + m ] . re *
mu1_re + T [ 9 * j + m ] . im * mu1_im ) + T [ ( 9 * j + m ) + 1 ] . re * r ;
T [ m + 9 * j ] . im = ( T [ 9 * j + m ] . im * mu1_re - mu1_im * rt1r ) + T
[ ( 9 * j + m ) + 1 ] . im * r ; rt1r = T [ ( 9 * j + m ) + 1 ] . im * mu1_re
+ T [ ( 9 * j + m ) + 1 ] . re * mu1_im ; T [ ( m + 9 * j ) + 1 ] . re = ( T
[ ( 9 * j + m ) + 1 ] . re * mu1_re - T [ ( 9 * j + m ) + 1 ] . im * mu1_im )
- r * t1_re ; T [ ( m + 9 * j ) + 1 ] . im = rt1r - r * t1_im ; } for ( j = 0
; j + 1 <= m + 2 ; j ++ ) { t1_re = T [ 9 * m + j ] . re ; t1_im = T [ 9 * m
+ j ] . im ; rt1r = T [ 9 * m + j ] . im * mu1_re + T [ 9 * m + j ] . re *
mu1_im ; T [ j + 9 * m ] . re = ( T [ 9 * m + j ] . re * mu1_re - T [ 9 * m +
j ] . im * mu1_im ) + T [ ( m + 1 ) * 9 + j ] . re * r ; T [ j + 9 * m ] . im
= T [ ( m + 1 ) * 9 + j ] . im * r + rt1r ; rt1r = T [ ( m + 1 ) * 9 + j ] .
re ; T [ j + 9 * ( m + 1 ) ] . re = ( T [ ( m + 1 ) * 9 + j ] . re * mu1_re +
T [ ( m + 1 ) * 9 + j ] . im * mu1_im ) - r * t1_re ; T [ j + 9 * ( m + 1 ) ]
. im = ( T [ ( m + 1 ) * 9 + j ] . im * mu1_re - mu1_im * rt1r ) - r * t1_im
; } for ( j = 0 ; j < 9 ; j ++ ) { t1_re = U [ 9 * m + j ] . re ; t1_im = U [
9 * m + j ] . im ; rt1r = U [ 9 * m + j ] . im * mu1_re + U [ 9 * m + j ] .
re * mu1_im ; U [ j + 9 * m ] . re = ( U [ 9 * m + j ] . re * mu1_re - U [ 9
* m + j ] . im * mu1_im ) + U [ ( m + 1 ) * 9 + j ] . re * r ; U [ j + 9 * m
] . im = U [ ( m + 1 ) * 9 + j ] . im * r + rt1r ; rt1r = U [ ( m + 1 ) * 9 +
j ] . re ; U [ j + 9 * ( m + 1 ) ] . re = ( U [ ( m + 1 ) * 9 + j ] . re *
mu1_re + U [ ( m + 1 ) * 9 + j ] . im * mu1_im ) - r * t1_re ; U [ j + 9 * (
m + 1 ) ] . im = ( U [ ( m + 1 ) * 9 + j ] . im * mu1_re - mu1_im * rt1r ) -
r * t1_im ; } T [ ( m + 9 * m ) + 1 ] . re = 0.0 ; T [ ( m + 9 * m ) + 1 ] .
im = 0.0 ; } } } static void d3jjyurfim ( creal_T x [ 81 ] ) { int32_T istart
; int32_T j ; int32_T i ; istart = 3 ; for ( j = 0 ; j < 7 ; j ++ ) { for ( i
= istart ; i < 10 ; i ++ ) { x [ ( i + 9 * j ) - 1 ] . re = 0.0 ; x [ ( i + 9
* j ) - 1 ] . im = 0.0 ; } istart ++ ; } } static void idbbxhzzmc ( const
real_T A [ 81 ] , creal_T V [ 81 ] , creal_T T [ 81 ] ) { real_T b_A [ 81 ] ;
real_T tau [ 8 ] ; real_T Vr [ 81 ] ; int32_T i ; if ( bh1hrlycek ( A ) ) {
for ( i = 0 ; i < 81 ; i ++ ) { V [ i ] . re = ( rtNaN ) ; V [ i ] . im = 0.0
; } d3jjyurfim ( V ) ; for ( i = 0 ; i < 81 ; i ++ ) { T [ i ] . re = ( rtNaN
) ; T [ i ] . im = 0.0 ; } } else { memcpy ( & b_A [ 0 ] , & A [ 0 ] , 81U *
sizeof ( real_T ) ) ; jxwaug1pc5 ( b_A , tau ) ; memcpy ( & Vr [ 0 ] , & b_A
[ 0 ] , 81U * sizeof ( real_T ) ) ; ifpuw5fuda ( 9 , 1 , 9 , Vr , 1 , tau , 1
) ; f3ikqo5yby ( b_A , Vr ) ; oerr3d2lo0 ( Vr , b_A , V , T ) ; } } static
boolean_T jg3q0qpu5h ( const creal_T T [ 81 ] ) { boolean_T p ; int32_T j ;
int32_T i ; int32_T exitg1 ; int32_T exitg2 ; j = 0 ; do { exitg2 = 0 ; if (
j + 1 < 10 ) { i = 1 ; do { exitg1 = 0 ; if ( i <= j ) { if ( ( T [ ( 9 * j +
i ) - 1 ] . re != 0.0 ) || ( T [ ( 9 * j + i ) - 1 ] . im != 0.0 ) ) { p =
false ; exitg1 = 1 ; } else { i ++ ; } } else { j ++ ; exitg1 = 2 ; } } while
( exitg1 == 0 ) ; if ( exitg1 == 1 ) { exitg2 = 1 ; } } else { p = true ;
exitg2 = 1 ; } } while ( exitg2 == 0 ) ; return p ; } static void jflkbipdbe
( creal_T * x ) { real_T xr ; real_T xi ; real_T absxr ; real_T absxi ; xr =
x -> re ; xi = x -> im ; if ( xi == 0.0 ) { if ( xr < 0.0 ) { absxr = 0.0 ;
xr = muDoubleScalarSqrt ( - xr ) ; } else { absxr = muDoubleScalarSqrt ( xr )
; xr = 0.0 ; } } else if ( xr == 0.0 ) { if ( xi < 0.0 ) { absxr =
muDoubleScalarSqrt ( - xi / 2.0 ) ; xr = - absxr ; } else { absxr =
muDoubleScalarSqrt ( xi / 2.0 ) ; xr = absxr ; } } else if (
muDoubleScalarIsNaN ( xr ) ) { absxr = xr ; } else if ( muDoubleScalarIsNaN (
xi ) ) { absxr = xi ; xr = xi ; } else if ( muDoubleScalarIsInf ( xi ) ) {
absxr = muDoubleScalarAbs ( xi ) ; xr = xi ; } else if ( muDoubleScalarIsInf
( xr ) ) { if ( xr < 0.0 ) { absxr = 0.0 ; xr = xi * - xr ; } else { absxr =
xr ; xr = 0.0 ; } } else { absxr = muDoubleScalarAbs ( xr ) ; absxi =
muDoubleScalarAbs ( xi ) ; if ( ( absxr > 4.4942328371557893E+307 ) || (
absxi > 4.4942328371557893E+307 ) ) { absxr *= 0.5 ; absxi *= 0.5 ; absxi =
muDoubleScalarHypot ( absxr , absxi ) ; if ( absxi > absxr ) { absxr =
muDoubleScalarSqrt ( absxr / absxi + 1.0 ) * muDoubleScalarSqrt ( absxi ) ; }
else { absxr = muDoubleScalarSqrt ( absxi ) * 1.4142135623730951 ; } } else {
absxr = muDoubleScalarSqrt ( ( muDoubleScalarHypot ( absxr , absxi ) + absxr
) * 0.5 ) ; } if ( xr > 0.0 ) { xr = xi / absxr * 0.5 ; } else { if ( xi <
0.0 ) { xr = - absxr ; } else { xr = absxr ; } absxr = xi / xr * 0.5 ; } } x
-> re = absxr ; x -> im = xr ; } static real_T ebbzxa51eo ( const real_T x [
81 ] ) { real_T y ; real_T s ; int32_T j ; int32_T i ; boolean_T exitg1 ; y =
0.0 ; j = 0 ; exitg1 = false ; while ( ( ! exitg1 ) && ( j < 9 ) ) { s = 0.0
; for ( i = 0 ; i < 9 ; i ++ ) { s += muDoubleScalarAbs ( x [ 9 * j + i ] ) ;
} if ( muDoubleScalarIsNaN ( s ) ) { y = ( rtNaN ) ; exitg1 = true ; } else {
if ( s > y ) { y = s ; } j ++ ; } } return y ; } static void ks0umh2kvmx (
real_T a , real_T x [ 36 ] , int32_T ix0 ) { int32_T k ; for ( k = ix0 ; k <=
ix0 + 5 ; k ++ ) { x [ k - 1 ] *= a ; } } static void gtjasxtio4 ( real_T x [
36 ] , int32_T ix0 , int32_T iy0 ) { int32_T ix ; int32_T iy ; real_T temp ;
int32_T k ; ix = ix0 - 1 ; iy = iy0 - 1 ; for ( k = 0 ; k < 6 ; k ++ ) { temp
= x [ ix ] ; x [ ix ] = x [ iy ] ; x [ iy ] = temp ; ix ++ ; iy ++ ; } }
static void gtjasxtio45 ( real_T x [ 54 ] , int32_T ix0 , int32_T iy0 ) {
int32_T ix ; int32_T iy ; real_T temp ; int32_T k ; ix = ix0 - 1 ; iy = iy0 -
1 ; for ( k = 0 ; k < 9 ; k ++ ) { temp = x [ ix ] ; x [ ix ] = x [ iy ] ; x
[ iy ] = temp ; ix ++ ; iy ++ ; } } static void odkxuqubc0 ( real_T * a ,
real_T * b , real_T * c , real_T * s ) { real_T roe ; real_T absa ; real_T
absb ; real_T scale ; real_T ads ; real_T bds ; roe = * b ; absa =
muDoubleScalarAbs ( * a ) ; absb = muDoubleScalarAbs ( * b ) ; if ( absa >
absb ) { roe = * a ; } scale = absa + absb ; if ( scale == 0.0 ) { * s = 0.0
; * c = 1.0 ; scale = 0.0 ; absa = 0.0 ; } else { ads = absa / scale ; bds =
absb / scale ; scale *= muDoubleScalarSqrt ( ads * ads + bds * bds ) ; if (
roe < 0.0 ) { scale = - scale ; } * c = * a / scale ; * s = * b / scale ; if
( absa > absb ) { absa = * s ; } else if ( * c != 0.0 ) { absa = 1.0 / * c ;
} else { absa = 1.0 ; } } * a = scale ; * b = absa ; } static void ky0gbvlahv
( real_T x [ 36 ] , int32_T ix0 , int32_T iy0 , real_T c , real_T s ) {
int32_T ix ; int32_T iy ; real_T temp ; int32_T k ; ix = ix0 - 1 ; iy = iy0 -
1 ; for ( k = 0 ; k < 6 ; k ++ ) { temp = c * x [ ix ] + s * x [ iy ] ; x [
iy ] = c * x [ iy ] - s * x [ ix ] ; x [ ix ] = temp ; iy ++ ; ix ++ ; } }
static void ky0gbvlahv0 ( real_T x [ 54 ] , int32_T ix0 , int32_T iy0 ,
real_T c , real_T s ) { int32_T ix ; int32_T iy ; real_T temp ; int32_T k ;
ix = ix0 - 1 ; iy = iy0 - 1 ; for ( k = 0 ; k < 9 ; k ++ ) { temp = c * x [
ix ] + s * x [ iy ] ; x [ iy ] = c * x [ iy ] - s * x [ ix ] ; x [ ix ] =
temp ; iy ++ ; ix ++ ; } } static void ks0umh2kvm ( real_T a , real_T x [ 54
] , int32_T ix0 ) { int32_T k ; for ( k = ix0 ; k <= ix0 + 8 ; k ++ ) { x [ k
- 1 ] *= a ; } } static real_T pcua3j5c4dq ( int32_T n , const real_T x [ 36
] , int32_T ix0 , const real_T y [ 36 ] , int32_T iy0 ) { real_T d ; int32_T
ix ; int32_T iy ; int32_T k ; d = 0.0 ; if ( ! ( n < 1 ) ) { ix = ix0 ; iy =
iy0 ; for ( k = 1 ; k <= n ; k ++ ) { d += x [ ix - 1 ] * y [ iy - 1 ] ; ix
++ ; iy ++ ; } } return d ; } static void dyou0ajb1milt ( int32_T n , real_T
a , int32_T ix0 , real_T y [ 36 ] , int32_T iy0 ) { int32_T ix ; int32_T iy ;
int32_T k ; if ( ! ( ( n < 1 ) || ( a == 0.0 ) ) ) { ix = ix0 - 1 ; iy = iy0
- 1 ; for ( k = 0 ; k < n ; k ++ ) { y [ iy ] += a * y [ ix ] ; ix ++ ; iy ++
; } } } static real_T pcua3j5c4d ( int32_T n , const real_T x [ 54 ] ,
int32_T ix0 , const real_T y [ 54 ] , int32_T iy0 ) { real_T d ; int32_T ix ;
int32_T iy ; int32_T k ; d = 0.0 ; if ( ! ( n < 1 ) ) { ix = ix0 ; iy = iy0 ;
for ( k = 1 ; k <= n ; k ++ ) { d += x [ ix - 1 ] * y [ iy - 1 ] ; ix ++ ; iy
++ ; } } return d ; } static void dyou0ajb1m ( int32_T n , real_T a , int32_T
ix0 , real_T y [ 54 ] , int32_T iy0 ) { int32_T ix ; int32_T iy ; int32_T k ;
if ( ! ( ( n < 1 ) || ( a == 0.0 ) ) ) { ix = ix0 - 1 ; iy = iy0 - 1 ; for (
k = 0 ; k < n ; k ++ ) { y [ iy ] += a * y [ ix ] ; ix ++ ; iy ++ ; } } }
static real_T evonddxn2x ( int32_T n , const real_T x [ 54 ] , int32_T ix0 )
{ real_T y ; real_T scale ; int32_T kend ; real_T absxk ; real_T t ; int32_T
k ; y = 0.0 ; if ( ! ( n < 1 ) ) { if ( n == 1 ) { y = muDoubleScalarAbs ( x
[ ix0 - 1 ] ) ; } else { scale = 2.2250738585072014E-308 ; kend = ( ix0 + n )
- 1 ; for ( k = ix0 ; k <= kend ; k ++ ) { absxk = muDoubleScalarAbs ( x [ k
- 1 ] ) ; if ( absxk > scale ) { t = scale / absxk ; y = y * t * t + 1.0 ;
scale = absxk ; } else { t = absxk / scale ; y += t * t ; } } y = scale *
muDoubleScalarSqrt ( y ) ; } } return y ; } static real_T evonddxn2xs (
int32_T n , const real_T x [ 6 ] , int32_T ix0 ) { real_T y ; real_T scale ;
int32_T kend ; real_T absxk ; real_T t ; int32_T k ; y = 0.0 ; if ( ! ( n < 1
) ) { if ( n == 1 ) { y = muDoubleScalarAbs ( x [ ix0 - 1 ] ) ; } else {
scale = 2.2250738585072014E-308 ; kend = ( ix0 + n ) - 1 ; for ( k = ix0 ; k
<= kend ; k ++ ) { absxk = muDoubleScalarAbs ( x [ k - 1 ] ) ; if ( absxk >
scale ) { t = scale / absxk ; y = y * t * t + 1.0 ; scale = absxk ; } else {
t = absxk / scale ; y += t * t ; } } y = scale * muDoubleScalarSqrt ( y ) ; }
} return y ; } static void dyou0ajb1mil ( int32_T n , real_T a , const real_T
x [ 9 ] , int32_T ix0 , real_T y [ 54 ] , int32_T iy0 ) { int32_T ix ;
int32_T iy ; int32_T k ; if ( ! ( ( n < 1 ) || ( a == 0.0 ) ) ) { ix = ix0 -
1 ; iy = iy0 - 1 ; for ( k = 0 ; k < n ; k ++ ) { y [ iy ] += a * x [ ix ] ;
ix ++ ; iy ++ ; } } } static void dyou0ajb1mi ( int32_T n , real_T a , const
real_T x [ 54 ] , int32_T ix0 , real_T y [ 9 ] , int32_T iy0 ) { int32_T ix ;
int32_T iy ; int32_T k ; if ( ! ( ( n < 1 ) || ( a == 0.0 ) ) ) { ix = ix0 -
1 ; iy = iy0 - 1 ; for ( k = 0 ; k < n ; k ++ ) { y [ iy ] += a * x [ ix ] ;
ix ++ ; iy ++ ; } } } static void otuiewre2g ( const real_T A [ 54 ] , real_T
U [ 54 ] , real_T s [ 6 ] , real_T V [ 36 ] ) { real_T b_A [ 54 ] ; real_T
b_s [ 6 ] ; real_T e [ 6 ] ; real_T work [ 9 ] ; real_T Vf [ 36 ] ; int32_T q
; boolean_T apply_transform ; int32_T iter ; real_T snorm ; real_T ztest0 ;
int32_T kase ; int32_T qs ; real_T ztest ; real_T smm1 ; real_T emm1 ; real_T
sqds ; real_T shift ; int32_T j_ii ; real_T varargin_1 [ 5 ] ; int32_T i ;
int32_T exitg1 ; boolean_T exitg2 ; memcpy ( & b_A [ 0 ] , & A [ 0 ] , 54U *
sizeof ( real_T ) ) ; for ( i = 0 ; i < 6 ; i ++ ) { b_s [ i ] = 0.0 ; e [ i
] = 0.0 ; } memset ( & work [ 0 ] , 0 , 9U * sizeof ( real_T ) ) ; memset ( &
U [ 0 ] , 0 , 54U * sizeof ( real_T ) ) ; memset ( & Vf [ 0 ] , 0 , 36U *
sizeof ( real_T ) ) ; for ( i = 0 ; i < 6 ; i ++ ) { iter = 9 * i + i ;
apply_transform = false ; snorm = evonddxn2x ( 9 - i , b_A , iter + 1 ) ; if
( snorm > 0.0 ) { apply_transform = true ; if ( b_A [ iter ] < 0.0 ) { b_s [
i ] = - snorm ; } else { b_s [ i ] = snorm ; } if ( muDoubleScalarAbs ( b_s [
i ] ) >= 1.0020841800044864E-292 ) { snorm = 1.0 / b_s [ i ] ; q = ( iter - i
) + 9 ; for ( qs = iter ; qs + 1 <= q ; qs ++ ) { b_A [ qs ] *= snorm ; } }
else { q = ( iter - i ) + 9 ; for ( qs = iter ; qs + 1 <= q ; qs ++ ) { b_A [
qs ] /= b_s [ i ] ; } } b_A [ iter ] ++ ; b_s [ i ] = - b_s [ i ] ; } else {
b_s [ i ] = 0.0 ; } for ( q = i + 1 ; q + 1 < 7 ; q ++ ) { qs = 9 * q + i ;
if ( apply_transform ) { dyou0ajb1m ( 9 - i , - ( pcua3j5c4d ( 9 - i , b_A ,
iter + 1 , b_A , qs + 1 ) / b_A [ i + 9 * i ] ) , iter + 1 , b_A , qs + 1 ) ;
} e [ q ] = b_A [ qs ] ; } for ( iter = i ; iter + 1 < 10 ; iter ++ ) { U [
iter + 9 * i ] = b_A [ 9 * i + iter ] ; } if ( i + 1 <= 4 ) { snorm =
evonddxn2xs ( 5 - i , e , i + 2 ) ; if ( snorm == 0.0 ) { e [ i ] = 0.0 ; }
else { if ( e [ i + 1 ] < 0.0 ) { e [ i ] = - snorm ; } else { e [ i ] =
snorm ; } snorm = e [ i ] ; if ( muDoubleScalarAbs ( e [ i ] ) >=
1.0020841800044864E-292 ) { snorm = 1.0 / e [ i ] ; for ( iter = i + 1 ; iter
+ 1 < 7 ; iter ++ ) { e [ iter ] *= snorm ; } } else { for ( iter = i + 1 ;
iter + 1 < 7 ; iter ++ ) { e [ iter ] /= snorm ; } } e [ i + 1 ] ++ ; e [ i ]
= - e [ i ] ; for ( iter = i + 1 ; iter + 1 < 10 ; iter ++ ) { work [ iter ]
= 0.0 ; } for ( iter = i + 1 ; iter + 1 < 7 ; iter ++ ) { dyou0ajb1mi ( 8 - i
, e [ iter ] , b_A , ( i + 9 * iter ) + 2 , work , i + 2 ) ; } for ( iter = i
+ 1 ; iter + 1 < 7 ; iter ++ ) { dyou0ajb1mil ( 8 - i , - e [ iter ] / e [ i
+ 1 ] , work , i + 2 , b_A , ( i + 9 * iter ) + 2 ) ; } } for ( iter = i + 1
; iter + 1 < 7 ; iter ++ ) { Vf [ iter + 6 * i ] = e [ iter ] ; } } } i = 4 ;
e [ 4 ] = b_A [ 49 ] ; e [ 5 ] = 0.0 ; for ( q = 5 ; q >= 0 ; q += - 1 ) {
iter = 9 * q + q ; if ( b_s [ q ] != 0.0 ) { for ( kase = q + 1 ; kase + 1 <
7 ; kase ++ ) { qs = ( 9 * kase + q ) + 1 ; dyou0ajb1m ( 9 - q , - (
pcua3j5c4d ( 9 - q , U , iter + 1 , U , qs ) / U [ iter ] ) , iter + 1 , U ,
qs ) ; } for ( qs = q ; qs + 1 < 10 ; qs ++ ) { U [ qs + 9 * q ] = - U [ 9 *
q + qs ] ; } U [ iter ] ++ ; for ( iter = 1 ; iter <= q ; iter ++ ) { U [ (
iter + 9 * q ) - 1 ] = 0.0 ; } } else { memset ( & U [ q * 9 ] , 0 , 9U *
sizeof ( real_T ) ) ; U [ iter ] = 1.0 ; } } for ( iter = 5 ; iter >= 0 ;
iter += - 1 ) { if ( ( iter + 1 <= 4 ) && ( e [ iter ] != 0.0 ) ) { q = ( 6 *
iter + iter ) + 2 ; for ( qs = iter + 1 ; qs + 1 < 7 ; qs ++ ) { kase = ( 6 *
qs + iter ) + 2 ; dyou0ajb1milt ( 5 - iter , - ( pcua3j5c4dq ( 5 - iter , Vf
, q , Vf , kase ) / Vf [ q - 1 ] ) , q , Vf , kase ) ; } } for ( q = 0 ; q <
6 ; q ++ ) { Vf [ q + 6 * iter ] = 0.0 ; } Vf [ iter + 6 * iter ] = 1.0 ; }
for ( iter = 0 ; iter < 6 ; iter ++ ) { ztest = e [ iter ] ; if ( b_s [ iter
] != 0.0 ) { ztest0 = muDoubleScalarAbs ( b_s [ iter ] ) ; snorm = b_s [ iter
] / ztest0 ; b_s [ iter ] = ztest0 ; if ( iter + 1 < 6 ) { ztest = e [ iter ]
/ snorm ; } ks0umh2kvm ( snorm , U , 1 + 9 * iter ) ; } if ( ( iter + 1 < 6 )
&& ( ztest != 0.0 ) ) { ztest0 = muDoubleScalarAbs ( ztest ) ; snorm = ztest0
/ ztest ; ztest = ztest0 ; b_s [ iter + 1 ] *= snorm ; ks0umh2kvmx ( snorm ,
Vf , 1 + 6 * ( iter + 1 ) ) ; } e [ iter ] = ztest ; } iter = 0 ; snorm = 0.0
; for ( q = 0 ; q < 6 ; q ++ ) { snorm = muDoubleScalarMax ( snorm ,
muDoubleScalarMax ( muDoubleScalarAbs ( b_s [ q ] ) , muDoubleScalarAbs ( e [
q ] ) ) ) ; } while ( ( i + 2 > 0 ) && ( ! ( iter >= 75 ) ) ) { kase = i + 1
; do { exitg1 = 0 ; q = kase ; if ( kase == 0 ) { exitg1 = 1 ; } else {
ztest0 = muDoubleScalarAbs ( e [ kase - 1 ] ) ; if ( ( ztest0 <= (
muDoubleScalarAbs ( b_s [ kase - 1 ] ) + muDoubleScalarAbs ( b_s [ kase ] ) )
* 2.2204460492503131E-16 ) || ( ( ztest0 <= 1.0020841800044864E-292 ) || ( (
iter > 20 ) && ( ztest0 <= 2.2204460492503131E-16 * snorm ) ) ) ) { e [ kase
- 1 ] = 0.0 ; exitg1 = 1 ; } else { kase -- ; } } } while ( exitg1 == 0 ) ;
if ( i + 1 == kase ) { kase = 4 ; } else { qs = i + 2 ; j_ii = i + 2 ; exitg2
= false ; while ( ( ! exitg2 ) && ( j_ii >= kase ) ) { qs = j_ii ; if ( j_ii
== kase ) { exitg2 = true ; } else { ztest0 = 0.0 ; if ( j_ii < i + 2 ) {
ztest0 = muDoubleScalarAbs ( e [ j_ii - 1 ] ) ; } if ( j_ii > kase + 1 ) {
ztest0 += muDoubleScalarAbs ( e [ j_ii - 2 ] ) ; } ztest = muDoubleScalarAbs
( b_s [ j_ii - 1 ] ) ; if ( ( ztest <= 2.2204460492503131E-16 * ztest0 ) || (
ztest <= 1.0020841800044864E-292 ) ) { b_s [ j_ii - 1 ] = 0.0 ; exitg2 = true
; } else { j_ii -- ; } } } if ( qs == kase ) { kase = 3 ; } else if ( i + 2
== qs ) { kase = 1 ; } else { kase = 2 ; q = qs ; } } switch ( kase ) { case
1 : ztest0 = e [ i ] ; e [ i ] = 0.0 ; for ( qs = i ; qs + 1 >= q + 1 ; qs --
) { ztest = b_s [ qs ] ; odkxuqubc0 ( & ztest , & ztest0 , & sqds , & smm1 )
; b_s [ qs ] = ztest ; if ( qs + 1 > q + 1 ) { ztest0 = e [ qs - 1 ] * - smm1
; e [ qs - 1 ] *= sqds ; } ky0gbvlahv ( Vf , 1 + 6 * qs , 1 + 6 * ( i + 1 ) ,
sqds , smm1 ) ; } break ; case 2 : ztest0 = e [ q - 1 ] ; e [ q - 1 ] = 0.0 ;
for ( qs = q ; qs + 1 <= i + 2 ; qs ++ ) { ztest = b_s [ qs ] ; odkxuqubc0 (
& ztest , & ztest0 , & sqds , & smm1 ) ; b_s [ qs ] = ztest ; ztest0 = - smm1
* e [ qs ] ; e [ qs ] *= sqds ; ky0gbvlahv0 ( U , 1 + 9 * qs , 1 + 9 * ( q -
1 ) , sqds , smm1 ) ; } break ; case 3 : varargin_1 [ 0 ] = muDoubleScalarAbs
( b_s [ i + 1 ] ) ; varargin_1 [ 1 ] = muDoubleScalarAbs ( b_s [ i ] ) ;
varargin_1 [ 2 ] = muDoubleScalarAbs ( e [ i ] ) ; varargin_1 [ 3 ] =
muDoubleScalarAbs ( b_s [ q ] ) ; varargin_1 [ 4 ] = muDoubleScalarAbs ( e [
q ] ) ; qs = 1 ; ztest = varargin_1 [ 0 ] ; if ( muDoubleScalarIsNaN (
varargin_1 [ 0 ] ) ) { kase = 2 ; exitg2 = false ; while ( ( ! exitg2 ) && (
kase < 6 ) ) { qs = kase ; if ( ! muDoubleScalarIsNaN ( varargin_1 [ kase - 1
] ) ) { ztest = varargin_1 [ kase - 1 ] ; exitg2 = true ; } else { kase ++ ;
} } } if ( qs < 5 ) { while ( qs + 1 < 6 ) { if ( varargin_1 [ qs ] > ztest )
{ ztest = varargin_1 [ qs ] ; } qs ++ ; } } ztest0 = b_s [ i + 1 ] / ztest ;
smm1 = b_s [ i ] / ztest ; emm1 = e [ i ] / ztest ; sqds = b_s [ q ] / ztest
; smm1 = ( ( smm1 + ztest0 ) * ( smm1 - ztest0 ) + emm1 * emm1 ) / 2.0 ; emm1
*= ztest0 ; emm1 *= emm1 ; if ( ( smm1 != 0.0 ) || ( emm1 != 0.0 ) ) { shift
= muDoubleScalarSqrt ( smm1 * smm1 + emm1 ) ; if ( smm1 < 0.0 ) { shift = -
shift ; } shift = emm1 / ( smm1 + shift ) ; } else { shift = 0.0 ; } ztest0 =
( sqds + ztest0 ) * ( sqds - ztest0 ) + shift ; ztest = e [ q ] / ztest *
sqds ; for ( qs = q + 1 ; qs <= i + 1 ; qs ++ ) { odkxuqubc0 ( & ztest0 , &
ztest , & sqds , & smm1 ) ; if ( qs > q + 1 ) { e [ qs - 2 ] = ztest0 ; }
ztest0 = b_s [ qs - 1 ] * sqds + e [ qs - 1 ] * smm1 ; e [ qs - 1 ] = e [ qs
- 1 ] * sqds - b_s [ qs - 1 ] * smm1 ; ztest = smm1 * b_s [ qs ] ; b_s [ qs ]
*= sqds ; ky0gbvlahv ( Vf , 1 + 6 * ( qs - 1 ) , 1 + 6 * qs , sqds , smm1 ) ;
odkxuqubc0 ( & ztest0 , & ztest , & sqds , & smm1 ) ; b_s [ qs - 1 ] = ztest0
; ztest0 = e [ qs - 1 ] * sqds + smm1 * b_s [ qs ] ; b_s [ qs ] = e [ qs - 1
] * - smm1 + sqds * b_s [ qs ] ; ztest = smm1 * e [ qs ] ; e [ qs ] *= sqds ;
ky0gbvlahv0 ( U , 1 + 9 * ( qs - 1 ) , 1 + 9 * qs , sqds , smm1 ) ; } e [ i ]
= ztest0 ; iter ++ ; break ; default : if ( b_s [ q ] < 0.0 ) { b_s [ q ] = -
b_s [ q ] ; ks0umh2kvmx ( - 1.0 , Vf , 1 + 6 * q ) ; } iter = q + 1 ; while (
( q + 1 < 6 ) && ( b_s [ q ] < b_s [ iter ] ) ) { ztest0 = b_s [ q ] ; b_s [
q ] = b_s [ iter ] ; b_s [ iter ] = ztest0 ; gtjasxtio4 ( Vf , 1 + 6 * q , 1
+ 6 * ( q + 1 ) ) ; gtjasxtio45 ( U , 1 + 9 * q , 1 + 9 * ( q + 1 ) ) ; q =
iter ; iter ++ ; } iter = 0 ; i -- ; break ; } } for ( i = 0 ; i < 6 ; i ++ )
{ s [ i ] = b_s [ i ] ; for ( iter = 0 ; iter < 6 ; iter ++ ) { V [ iter + 6
* i ] = Vf [ 6 * i + iter ] ; } } } void MdlInitialize ( void ) { memcpy ( &
rtX . fy10ebt42l [ 0 ] , & rtP . x0 [ 0 ] , 12U * sizeof ( real_T ) ) ; }
void MdlStart ( void ) { { void * * slioCatalogueAddr = rt_slioCatalogueAddr
( ) ; void * r2 = ( NULL ) ; void * * pOSigstreamManagerAddr = ( NULL ) ;
const char * errorCreatingOSigstreamManager = ( NULL ) ; const char *
errorAddingR2SharedResource = ( NULL ) ; * slioCatalogueAddr =
rtwGetNewSlioCatalogue ( rt_GetMatSigLogSelectorFileName ( ) ) ;
errorAddingR2SharedResource = rtwAddR2SharedResource (
rtwGetPointerFromUniquePtr ( rt_slioCatalogue ( ) ) , 1 ) ; if (
errorAddingR2SharedResource != ( NULL ) ) { rtwTerminateSlioCatalogue (
slioCatalogueAddr ) ; * slioCatalogueAddr = ( NULL ) ; ssSetErrorStatus ( rtS
, errorAddingR2SharedResource ) ; return ; } r2 = rtwGetR2SharedResource (
rtwGetPointerFromUniquePtr ( rt_slioCatalogue ( ) ) ) ;
pOSigstreamManagerAddr = rt_GetOSigstreamManagerAddr ( ) ;
errorCreatingOSigstreamManager = rtwOSigstreamManagerCreateInstance (
rt_GetMatSigLogSelectorFileName ( ) , r2 , pOSigstreamManagerAddr ) ; if (
errorCreatingOSigstreamManager != ( NULL ) ) { * pOSigstreamManagerAddr = (
NULL ) ; ssSetErrorStatus ( rtS , errorCreatingOSigstreamManager ) ; return ;
} } { static int_T rt_ToWksWidths [ ] = { 12 } ; static int_T
rt_ToWksNumDimensions [ ] = { 1 } ; static int_T rt_ToWksDimensions [ ] = {
12 } ; static boolean_T rt_ToWksIsVarDims [ ] = { 0 } ; static void *
rt_ToWksCurrSigDims [ ] = { ( NULL ) } ; static int_T rt_ToWksCurrSigDimsSize
[ ] = { 4 } ; static BuiltInDTypeId rt_ToWksDataTypeIds [ ] = { SS_DOUBLE } ;
static int_T rt_ToWksComplexSignals [ ] = { 0 } ; static int_T
rt_ToWksFrameData [ ] = { 0 } ; static const char_T * rt_ToWksLabels [ ] = {
"" } ; static RTWLogSignalInfo rt_ToWksSignalInfo = { 1 , rt_ToWksWidths ,
rt_ToWksNumDimensions , rt_ToWksDimensions , rt_ToWksIsVarDims ,
rt_ToWksCurrSigDims , rt_ToWksCurrSigDimsSize , rt_ToWksDataTypeIds ,
rt_ToWksComplexSignals , rt_ToWksFrameData , { rt_ToWksLabels } , ( NULL ) ,
( NULL ) , ( NULL ) , { ( NULL ) } , { ( NULL ) } , ( NULL ) , ( NULL ) } ;
static const char_T rt_ToWksBlockName [ ] = "sliding_car/To Workspace" ; rtDW
. ftipop2ikq . LoggedData = rt_CreateStructLogVar ( ssGetRTWLogInfo ( rtS ) ,
ssGetTStart ( rtS ) , ssGetTFinal ( rtS ) , 0.0 , ( & ssGetErrorStatus ( rtS
) ) , "x" , 1 , 0 , 1 , 0.0 , & rt_ToWksSignalInfo , rt_ToWksBlockName ) ; if
( rtDW . ftipop2ikq . LoggedData == ( NULL ) ) return ; } MdlInitialize ( ) ;
{ bool externalInputIsInDatasetFormat = false ; void * pISigstreamManager =
rt_GetISigstreamManager ( ) ; rtwISigstreamManagerGetInputIsInDatasetFormat (
pISigstreamManager , & externalInputIsInDatasetFormat ) ; if (
externalInputIsInDatasetFormat ) { } } } void MdlOutputs ( int_T tid ) {
real_T krg2bizi3l [ 81 ] ; real_T oclxa3gpdt [ 81 ] ; real_T t2 ; real_T t3 ;
real_T t5 ; real_T t8 ; real_T t9 ; real_T t10 ; real_T t11 ; real_T t12 ;
real_T t13 ; real_T t14 ; real_T t15 ; real_T t16 ; real_T t17 ; real_T t18 ;
real_T t21 ; real_T t22 ; real_T t23 ; real_T t24 ; real_T t28 ; real_T t29 ;
real_T t31 ; real_T t32 ; real_T t34 ; real_T t4 ; real_T t7 ; real_T t19 ;
real_T t20 ; real_T t25 ; real_T t26 ; real_T t27 ; real_T t30 ; real_T t77 ;
real_T t106 ; real_T t107 ; real_T t100 ; real_T t137 ; real_T t33 ; real_T
t35 ; real_T t36 ; real_T t37 ; real_T t38 ; real_T t40 ; real_T t41 ; real_T
t42 ; real_T t43 ; real_T t45 ; real_T t46 ; real_T t47 ; real_T t48 ; real_T
t49 ; real_T t50 ; real_T t51 ; real_T t52 ; real_T t53 ; real_T t54 ; real_T
t55 ; real_T t56 ; real_T t57 ; real_T t58 ; real_T t59 ; real_T t60 ; real_T
t61 ; real_T t62 ; real_T t63 ; real_T t64 ; real_T t65 ; real_T t66 ; real_T
t67 ; real_T t68 ; real_T t69 ; real_T t70 ; real_T t71 ; real_T t72 ; real_T
t73 ; real_T t74 ; real_T t75 ; real_T t76 ; real_T t78 ; real_T t79 ; real_T
t80 ; real_T t81 ; real_T t82 ; real_T t83 ; real_T t84 ; real_T t85 ; real_T
t86 ; real_T t87 ; real_T t88 ; real_T t89 ; real_T t90 ; real_T t91 ; real_T
t92 ; real_T t93 ; real_T t94 ; real_T t95 ; real_T t96 ; real_T t97 ; real_T
t98 ; real_T t99 ; real_T t101 ; real_T t102 ; real_T t103 ; real_T t104 ;
real_T t105 ; real_T t108 ; real_T t109 ; real_T t110 ; real_T t111 ; real_T
t112 ; real_T t113 ; real_T t114 ; real_T t115 ; real_T t116 ; real_T t117 ;
real_T t118 ; real_T t120 ; real_T t122 ; real_T t123 ; real_T t124 ; real_T
t125 ; real_T t127 ; real_T t129 ; real_T t130 ; real_T t131 ; real_T t132 ;
real_T t133 ; real_T t134 ; real_T t135 ; real_T t136 ; real_T t139 ; real_T
t140 ; real_T t141 ; real_T t142 ; real_T t143 ; real_T t144 ; real_T t145 ;
real_T t146 ; real_T t147 ; real_T t148 ; real_T t149 ; real_T t151 ; real_T
t153 ; real_T t155 ; real_T t156 ; real_T t159 ; real_T t160 ; real_T t164 ;
real_T t166 ; real_T t170 ; real_T t172 ; real_T t173 ; real_T t174 ; real_T
t175 ; real_T t177 ; real_T t178 ; real_T t179 ; real_T t180 ; real_T t181 ;
real_T t182 ; real_T t185 ; real_T t186 ; real_T t194 ; real_T t195 ; real_T
t199 ; real_T t200 ; real_T t210 ; real_T t211 ; real_T t212 ; real_T t213 ;
real_T t214 ; real_T t215 ; real_T t216 ; real_T t217 ; real_T t219 ; real_T
t220 ; real_T t221 ; real_T t222 ; real_T t223 ; real_T t224 ; real_T t225 ;
real_T t226 ; real_T t227 ; real_T t228 ; real_T t230 ; real_T t231 ; real_T
t232 ; real_T t233 ; real_T t234 ; real_T t256 ; real_T t257 ; real_T t258 ;
real_T t259 ; real_T t260 ; real_T t261 ; real_T t262 ; real_T t263 ; real_T
t264 ; real_T t265 ; real_T t266 ; real_T t267 ; real_T t268 ; real_T t269 ;
real_T t271 ; real_T t273 ; real_T t274 ; real_T t275 ; real_T t276 ; real_T
t277 ; real_T t278 ; real_T t279 ; real_T t280 ; real_T t281 ; real_T t282 ;
real_T t283 ; real_T t284 ; real_T t285 ; real_T t286 ; real_T t287 ; real_T
t290 ; real_T t291 ; real_T t292 ; real_T t293 ; real_T t294 ; real_T t295 ;
real_T t296 ; real_T t297 ; real_T t298 ; real_T t299 ; real_T t300 ; real_T
t301 ; real_T t302 ; real_T t303 ; real_T t304 ; real_T t307 ; real_T t308 ;
real_T t309 ; real_T t310 ; real_T t311 ; real_T t312 ; real_T t313 ; real_T
t314 ; real_T t315 ; real_T t316 ; real_T t317 ; real_T t318 ; real_T t319 ;
real_T t320 ; real_T t322 ; real_T t323 ; real_T t324 ; real_T t325 ; real_T
t326 ; real_T t327 ; real_T t328 ; real_T t329 ; real_T t330 ; real_T t331 ;
real_T t332 ; real_T t333 ; real_T t334 ; real_T t335 ; real_T t336 ; real_T
t337 ; real_T t338 ; real_T t339 ; real_T t340 ; real_T t341 ; real_T t342 ;
real_T t343 ; real_T t344 ; real_T t345 ; real_T t346 ; real_T t347 ; real_T
t348 ; real_T t349 ; real_T t350 ; real_T t351 ; real_T t352 ; real_T t353 ;
real_T t354 ; real_T t355 ; real_T t356 ; real_T t357 ; real_T t358 ; real_T
t359 ; real_T t360 ; real_T t361 ; real_T t362 ; real_T t363 ; real_T t364 ;
real_T t365 ; real_T t366 ; real_T t368 ; real_T t369 ; real_T t370 ; real_T
t371 ; real_T t372 ; real_T t373 ; real_T t374 ; real_T t375 ; real_T t376 ;
real_T t377 ; real_T t378 ; real_T t379 ; real_T t380 ; real_T t381 ; real_T
t382 ; real_T t383 ; real_T t384 ; real_T t385 ; real_T t386 ; real_T t387 ;
real_T t388 ; real_T t389 ; real_T t390 ; real_T t391 ; real_T t392 ; real_T
t393 ; real_T t394 ; real_T t395 ; real_T t396 ; real_T t397 ; real_T t398 ;
real_T t399 ; real_T t400 ; real_T t402 ; real_T t404 ; real_T t405 ; real_T
t406 ; real_T t407 ; real_T t408 ; real_T t409 ; real_T t410 ; real_T t411 ;
real_T t412 ; real_T t413 ; real_T t414 ; real_T t415 ; real_T t416 ; real_T
t417 ; real_T t421 ; real_T t422 ; real_T t423 ; real_T t424 ; real_T t425 ;
real_T t426 ; real_T t427 ; real_T t428 ; real_T t429 ; real_T t430 ; real_T
t431 ; real_T t432 ; real_T t433 ; real_T t434 ; real_T t435 ; real_T t436 ;
real_T t437 ; real_T t438 ; real_T t439 ; real_T t440 ; real_T t441 ; real_T
t442 ; real_T t443 ; real_T t444 ; real_T t445 ; real_T t446 ; real_T t447 ;
real_T t448 ; real_T t449 ; real_T t450 ; real_T t451 ; real_T t453 ; real_T
t454 ; real_T t455 ; real_T t456 ; real_T t458 ; real_T t459 ; real_T t460 ;
real_T t461 ; real_T t462 ; real_T t463 ; real_T t464 ; real_T t465 ; real_T
t466 ; real_T t467 ; real_T t468 ; real_T t469 ; real_T t470 ; real_T t471 ;
real_T t472 ; real_T t473 ; real_T t474 ; real_T t475 ; real_T t476 ; real_T
t477 ; real_T t478 ; real_T t479 ; real_T t481 ; real_T t482 ; real_T t483 ;
real_T t484 ; real_T t485 ; real_T t486 ; real_T t487 ; real_T t488 ; real_T
t489 ; real_T t490 ; real_T t491 ; real_T t492 ; real_T t494 ; real_T t495 ;
real_T t496 ; real_T t497 ; real_T t498 ; real_T t499 ; real_T t500 ; real_T
t502 ; real_T t503 ; real_T t504 ; real_T t505 ; real_T t506 ; real_T t507 ;
real_T t508 ; real_T t509 ; real_T t510 ; real_T t511 ; real_T t512 ; real_T
t513 ; real_T t514 ; real_T t515 ; real_T x [ 9 ] ; int32_T p1 ; int32_T p2 ;
int32_T p3 ; int32_T itmp ; real_T R6_th_i [ 81 ] ; real_T R6_th_o [ 81 ] ;
static const int8_T varargin_2 [ 49 ] = { 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 ,
0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0
, 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 ,
1 } ; static const int8_T b_a [ 9 ] = { 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 } ;
creal_T X_p [ 81 ] ; creal_T R [ 81 ] ; creal_T Q [ 81 ] ; real_T B_1delta [
54 ] ; real_T pB_1delta [ 54 ] ; real_T X_e [ 54 ] ; real_T V [ 36 ] ;
int32_T r ; real_T U [ 54 ] ; real_T s [ 6 ] ; boolean_T b_p ; int32_T ia ;
int32_T ib ; int32_T b_ic ; int8_T I [ 81 ] ; real_T ehrq52oenb [ 9 ] ;
real_T owi2j0naiy [ 9 ] ; real_T pypyr02emi [ 54 ] ; real_T nn5hyolh34 [ 27 ]
; real_T g4r1yovtie [ 54 ] ; real_T mxorse3uag [ 27 ] ; real_T X_i [ 81 ] ;
real_T mjespxcs1o [ 27 ] ; creal_T Q_p [ 81 ] ; real_T mjespxcs1o_p [ 27 ] ;
real_T ns2qq2s0fy [ 18 ] ; real_T ns2qq2s0fy_p [ 6 ] ; real_T mjespxcs1o_e [
3 ] ; real_T mjespxcs1o_i [ 3 ] ; real_T R6_th_i_p [ 81 ] ; real_T F1_vec [ 9
] ; real_T F2_vec [ 9 ] ; real_T R6_th_o_p [ 9 ] ; real_T mjespxcs1o_m [ 3 ]
; boolean_T exitg1 ; memcpy ( & rtB . hkbmt1bwgv [ 0 ] , & rtX . fy10ebt42l [
0 ] , 12U * sizeof ( real_T ) ) ; { double locTime = ssGetTaskTime ( rtS , 0
) ; ; if ( ssGetLogOutput ( rtS ) ) { { double locTime = ssGetTaskTime ( rtS
, 0 ) ; ; if ( rtwTimeInLoggingInterval ( rtliGetLoggingInterval (
ssGetRootSS ( rtS ) -> mdlInfo -> rtwLogInfo ) , locTime ) ) {
rt_UpdateStructLogVar ( ( StructLogVar * ) rtDW . ftipop2ikq . LoggedData , &
locTime , & rtB . hkbmt1bwgv [ 0 ] ) ; } } } } t2 = muDoubleScalarTan ( rtB .
hkbmt1bwgv [ 3 ] ) ; t3 = 1.0 / rtP . L ; t5 = t2 * rtP . w + rtP . L ; t8 =
muDoubleScalarTan ( 1.0 / t5 * t2 ) ; t9 = rtB . hkbmt1bwgv [ 3 ] + rtB .
hkbmt1bwgv [ 2 ] ; t10 = muDoubleScalarCos ( t9 ) ; t11 = muDoubleScalarSin (
t9 ) ; t13 = muDoubleScalarCos ( rtB . hkbmt1bwgv [ 3 ] ) ; t14 =
muDoubleScalarSin ( rtB . hkbmt1bwgv [ 3 ] ) ; t15 = t14 * rtP . w * 0.5 ;
t16 = 0.0 * t10 * 0.0 ; t17 = 0.0 * t11 * 0.0 ; t18 = ( t15 - rtP . L * t13 )
* 0.0 ; t21 = muDoubleScalarAtan ( rtP . L * t8 ) + rtB . hkbmt1bwgv [ 2 ] ;
t22 = rtB . hkbmt1bwgv [ 4 ] + rtB . hkbmt1bwgv [ 2 ] ; t24 = rtP . L * rtP .
L ; t28 = 1.0 / muDoubleScalarSqrt ( t8 * t8 * t24 + 1.0 ) ; t29 =
muDoubleScalarSin ( t21 ) ; t31 = 0.0 * muDoubleScalarCos ( t22 ) ; t32 =
muDoubleScalarCos ( t21 ) ; t34 = 0.0 * muDoubleScalarSin ( t22 ) ; t9 =
muDoubleScalarSin ( rtB . hkbmt1bwgv [ 4 ] ) * rtP . w * 0.5 + rtP . L *
muDoubleScalarCos ( rtB . hkbmt1bwgv [ 4 ] ) ; pypyr02emi [ 0 ] = 0.0 ;
pypyr02emi [ 1 ] = 0.0 ; pypyr02emi [ 2 ] = t10 + t16 ; pypyr02emi [ 3 ] = -
t11 + t16 ; pypyr02emi [ 4 ] = t31 + t32 ; pypyr02emi [ 5 ] = - t29 + t31 ;
pypyr02emi [ 6 ] = 0.0 ; pypyr02emi [ 7 ] = 0.0 ; pypyr02emi [ 8 ] = t11 +
t17 ; pypyr02emi [ 9 ] = t10 + t17 ; pypyr02emi [ 10 ] = t29 + t34 ;
pypyr02emi [ 11 ] = t32 + t34 ; pypyr02emi [ 12 ] = 0.0 ; pypyr02emi [ 13 ] =
0.0 ; pypyr02emi [ 14 ] = ( t15 + t18 ) - rtP . L * t13 ; pypyr02emi [ 15 ] =
( rtP . L * t14 + t18 ) + t13 * rtP . w * 0.5 ; pypyr02emi [ 16 ] = ( - rtP .
L * t28 - 0.0 * t9 ) - rtP . L * t8 * t28 * rtP . w * 0.5 ; pypyr02emi [ 17 ]
= ( t28 * rtP . w * - 0.5 - 0.0 * t9 ) + t8 * t24 * t28 ; pypyr02emi [ 18 ] =
( t2 * t2 + 1.0 ) * t3 * ( rtP . L - rtP . L * t8 * rtP . w ) ; pypyr02emi [
19 ] = 0.0 ; pypyr02emi [ 20 ] = 0.0 ; pypyr02emi [ 21 ] = 0.0 ; pypyr02emi [
22 ] = 0.0 ; pypyr02emi [ 23 ] = 0.0 ; pypyr02emi [ 24 ] = ( t8 * t8 * t24 +
1.0 ) * ( - t3 * t5 ) ; pypyr02emi [ 25 ] = 0.0 ; pypyr02emi [ 26 ] = 0.0 ;
pypyr02emi [ 27 ] = 0.0 ; pypyr02emi [ 28 ] = 0.0 ; pypyr02emi [ 29 ] = 0.0 ;
pypyr02emi [ 30 ] = 0.0 ; pypyr02emi [ 31 ] = 0.0 ; pypyr02emi [ 32 ] = - rtP
. R ; pypyr02emi [ 33 ] = 0.0 ; pypyr02emi [ 34 ] = 0.0 ; pypyr02emi [ 35 ] =
0.0 ; pypyr02emi [ 36 ] = 0.0 ; pypyr02emi [ 37 ] = 0.0 ; pypyr02emi [ 38 ] =
0.0 ; pypyr02emi [ 39 ] = 0.0 ; pypyr02emi [ 40 ] = - rtP . R ; pypyr02emi [
41 ] = 0.0 ; pypyr02emi [ 42 ] = 0.0 ; pypyr02emi [ 43 ] = - t2 * t3 * rtP .
w - 1.0 ; pypyr02emi [ 44 ] = 0.0 ; pypyr02emi [ 45 ] = 0.0 ; pypyr02emi [ 46
] = 0.0 ; pypyr02emi [ 47 ] = 0.0 ; pypyr02emi [ 48 ] = 0.0 ; pypyr02emi [ 49
] = 1.0 ; pypyr02emi [ 50 ] = 0.0 ; pypyr02emi [ 51 ] = 0.0 ; pypyr02emi [ 52
] = 0.0 ; pypyr02emi [ 53 ] = 0.0 ; t2 = muDoubleScalarTan ( rtB . hkbmt1bwgv
[ 3 ] ) ; t3 = rtB . hkbmt1bwgv [ 3 ] + rtB . hkbmt1bwgv [ 2 ] ; t4 =
muDoubleScalarCos ( t3 ) ; t5 = t2 * rtP . w + rtP . L ; t7 = 1.0 / t5 ; t9 =
muDoubleScalarTan ( t2 * t7 ) ; t10 = rtP . L * rtP . L ; t13 =
muDoubleScalarAtan ( rtP . L * t9 ) + rtB . hkbmt1bwgv [ 2 ] ; t14 =
muDoubleScalarCos ( t13 ) ; t16 = t9 * t9 * t10 ; t18 = muDoubleScalarSqrt (
t16 + 1.0 ) ; t19 = muDoubleScalarSin ( t3 ) ; t21 = muDoubleScalarCos ( rtB
. hkbmt1bwgv [ 3 ] ) ; t23 = muDoubleScalarSin ( rtB . hkbmt1bwgv [ 3 ] ) ;
t24 = rtB . hkbmt1bwgv [ 4 ] + rtB . hkbmt1bwgv [ 2 ] ; t25 =
muDoubleScalarSin ( t24 ) ; t26 = muDoubleScalarCos ( rtB . hkbmt1bwgv [ 4 ]
) ; t27 = muDoubleScalarSin ( rtB . hkbmt1bwgv [ 4 ] ) ; t28 =
muDoubleScalarSin ( t13 ) ; t29 = t14 * t14 ; t30 = t28 * t28 ; t31 =
muDoubleScalarCos ( t24 ) ; t77 = 1.0 / ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( rtP . L * t4 * t28 * 2.0 + t4 * t14 * rtP . w ) +
t19 * t28 * rtP . w ) + rtP . L * t18 * t23 * t29 * 2.0 ) + rtP . L * t18 *
t23 * t30 * 2.0 ) + t18 * t21 * t29 * rtP . w ) + t18 * t21 * t30 * rtP . w )
+ rtP . L * 0.0 * t4 * t14 * 0.0 * 2.0 ) + 0.0 * t4 * 0.0 * t31 * rtP . w ) +
rtP . L * 0.0 * t19 * 0.0 * t28 * 2.0 ) + 0.0 * t14 * t19 * 0.0 * rtP . w ) +
0.0 * t19 * 0.0 * t25 * rtP . w ) + rtP . L * t4 * t9 * t28 * rtP . w ) + 0.0
* t4 * t9 * t10 * 0.0 * t28 * 2.0 ) + 0.0 * t18 * 0.0 * t23 * t29 * rtP . w )
+ 0.0 * t18 * 0.0 * t23 * t30 * rtP . w ) + rtP . L * 0.0 * t4 * t9 * t14 *
0.0 * rtP . w ) + rtP . L * 0.0 * t9 * t19 * 0.0 * t28 * rtP . w ) + rtP . L
* 0.0 * 0.0 * t4 * 0.0 * 0.0 * t25 * 2.0 ) + rtP . L * 0.0 * t4 * t14 * t18 *
0.0 * t26 * 2.0 ) + rtP . L * 0.0 * t4 * t18 * 0.0 * t26 * t28 * 2.0 ) + rtP
. L * 0.0 * t14 * t18 * 0.0 * t23 * t31 * 2.0 ) + 0.0 * t19 * 0.0 * 0.0 * t31
* rtP . w ) + rtP . L * 0.0 * t14 * t18 * 0.0 * t23 * t25 * 2.0 ) + rtP . L *
0.0 * t18 * t19 * 0.0 * t26 * t28 * 2.0 ) + 0.0 * t14 * t18 * t21 * 0.0 * t31
* rtP . w ) + rtP . L * 0.0 * t18 * 0.0 * t23 * t25 * t28 * 2.0 ) + 0.0 * t4
* t14 * t18 * 0.0 * t27 * rtP . w ) + 0.0 * t14 * t18 * t21 * 0.0 * t25 * rtP
. w ) + 0.0 * t4 * t18 * 0.0 * t27 * t28 * rtP . w ) + 0.0 * t18 * t21 * 0.0
* t25 * t28 * rtP . w ) + 0.0 * t18 * t19 * 0.0 * t27 * t28 * rtP . w ) + 0.0
* t4 * t9 * t10 * 0.0 * 0.0 * t25 * 2.0 ) + 0.0 * t4 * t14 * t18 * 0.0 * 0.0
* t27 * rtP . w ) + 0.0 * t14 * t18 * 0.0 * 0.0 * t23 * t31 * rtP . w ) + 0.0
* t14 * t18 * t19 * 0.0 * 0.0 * t27 * rtP . w ) + 0.0 * t14 * t18 * 0.0 * 0.0
* t23 * t25 * rtP . w ) + 0.0 * t18 * t19 * 0.0 * 0.0 * t27 * t28 * rtP . w )
+ 0.0 * t18 * 0.0 * 0.0 * t23 * t25 * t28 * rtP . w ) + rtP . L * 0.0 * 0.0 *
t4 * t9 * 0.0 * 0.0 * t25 * rtP . w ) + rtP . L * 0.0 * 0.0 * t4 * t14 * t18
* 0.0 * 0.0 * t26 * 2.0 ) + rtP . L * 0.0 * 0.0 * t18 * 0.0 * t21 * 0.0 * t28
* t31 * 2.0 ) + rtP . L * 0.0 * 0.0 * t14 * t18 * t19 * 0.0 * 0.0 * t26 * 2.0
) + rtP . L * 0.0 * 0.0 * t18 * t19 * 0.0 * 0.0 * t26 * t28 * 2.0 ) - rtP . L
* t14 * t19 * 2.0 ) - t4 * t9 * t10 * t14 * 2.0 ) - t9 * t10 * t19 * t28 *
2.0 ) - rtP . L * 0.0 * t4 * 0.0 * t31 * 2.0 ) - rtP . L * 0.0 * t19 * 0.0 *
t25 * 2.0 ) - 0.0 * t4 * 0.0 * t28 * rtP . w ) - rtP . L * t9 * t14 * t19 *
rtP . w ) - 0.0 * t9 * t10 * t14 * t19 * 0.0 * 2.0 ) - 0.0 * t9 * t10 * t19 *
0.0 * t25 * 2.0 ) - rtP . L * 0.0 * t18 * 0.0 * t21 * t29 * 2.0 ) - rtP . L *
0.0 * t18 * 0.0 * t21 * t30 * 2.0 ) - 0.0 * t4 * t9 * t10 * 0.0 * t31 * 2.0 )
- rtP . L * 0.0 * t4 * t9 * 0.0 * t31 * rtP . w ) - rtP . L * 0.0 * t9 * t19
* 0.0 * t25 * rtP . w ) - rtP . L * 0.0 * 0.0 * t19 * 0.0 * 0.0 * t31 * 2.0 )
- rtP . L * 0.0 * t14 * t18 * t19 * 0.0 * t26 * 2.0 ) - 0.0 * t4 * 0.0 * 0.0
* t25 * rtP . w ) - rtP . L * 0.0 * t18 * 0.0 * t23 * t28 * t31 * 2.0 ) - 0.0
* t18 * t21 * 0.0 * t28 * t31 * rtP . w ) - 0.0 * t14 * t18 * t19 * 0.0 * t27
* rtP . w ) - 0.0 * t9 * t10 * t19 * 0.0 * 0.0 * t31 * 2.0 ) - 0.0 * t4 * t18
* 0.0 * 0.0 * t27 * t28 * rtP . w ) - 0.0 * t18 * 0.0 * 0.0 * t23 * t28 * t31
* rtP . w ) - rtP . L * 0.0 * 0.0 * t9 * t19 * 0.0 * 0.0 * t31 * rtP . w ) -
rtP . L * 0.0 * 0.0 * t14 * t18 * 0.0 * t21 * 0.0 * t31 * 2.0 ) - rtP . L *
0.0 * 0.0 * t4 * t18 * 0.0 * 0.0 * t26 * t28 * 2.0 ) - rtP . L * 0.0 * 0.0 *
t14 * t18 * 0.0 * t21 * 0.0 * t25 * 2.0 ) - rtP . L * 0.0 * 0.0 * t18 * 0.0 *
t21 * 0.0 * t25 * t28 * 2.0 ) ; t106 = t4 * t4 ; t107 = t19 * t19 ;
nn5hyolh34 [ 0 ] = 0.0 ; nn5hyolh34 [ 1 ] = 0.0 ; nn5hyolh34 [ 2 ] = 0.0 ;
nn5hyolh34 [ 3 ] = - ( ( t16 + 1.0 ) * t5 ) / ( ( t2 * t2 + 1.0 ) * rtP . L *
( t9 * rtP . w - 1.0 ) ) ; nn5hyolh34 [ 4 ] = 1.0 ; nn5hyolh34 [ 5 ] = 0.0 ;
nn5hyolh34 [ 6 ] = 0.0 ; nn5hyolh34 [ 7 ] = 0.0 ; nn5hyolh34 [ 8 ] = 0.0 ;
nn5hyolh34 [ 9 ] = ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( rtP . R * t4 * rtP . w - rtP
. R * t4 * t9 * t10 * 2.0 ) + rtP . L * rtP . R * t14 * t18 * t23 * 2.0 ) +
rtP . R * 0.0 * t19 * 0.0 * rtP . w ) + rtP . R * t14 * t18 * t21 * rtP . w )
- rtP . R * 0.0 * t9 * t10 * t19 * 0.0 * 2.0 ) + rtP . L * rtP . R * 0.0 * t4
* t18 * 0.0 * t26 * 2.0 ) - rtP . L * rtP . R * 0.0 * t14 * t18 * 0.0 * t21 *
2.0 ) + rtP . L * rtP . R * 0.0 * t18 * 0.0 * t23 * t25 * 2.0 ) + rtP . R *
0.0 * t4 * t18 * 0.0 * t27 * rtP . w ) + rtP . R * 0.0 * t14 * t18 * 0.0 *
t23 * rtP . w ) + rtP . R * 0.0 * t18 * t21 * 0.0 * t25 * rtP . w ) + rtP . L
* rtP . R * 0.0 * 0.0 * t18 * t19 * 0.0 * 0.0 * t26 * 2.0 ) - rtP . L * rtP .
R * 0.0 * 0.0 * t18 * 0.0 * t21 * 0.0 * t25 * 2.0 ) + rtP . R * 0.0 * 0.0 *
t18 * t19 * 0.0 * 0.0 * t27 * rtP . w ) + rtP . R * 0.0 * 0.0 * t18 * 0.0 *
0.0 * t23 * t25 * rtP . w ) * t77 ; nn5hyolh34 [ 10 ] = ( ( ( ( ( ( ( ( ( ( (
( ( ( ( rtP . R * t19 * rtP . w - rtP . R * t9 * t10 * t19 * 2.0 ) + rtP . L
* rtP . R * t18 * t23 * t28 * 2.0 ) - rtP . R * 0.0 * t4 * 0.0 * rtP . w ) +
rtP . R * t18 * t21 * t28 * rtP . w ) + rtP . R * 0.0 * t4 * t9 * t10 * 0.0 *
2.0 ) + rtP . L * rtP . R * 0.0 * t18 * t19 * 0.0 * t26 * 2.0 ) - rtP . L *
rtP . R * 0.0 * t18 * 0.0 * t21 * t28 * 2.0 ) - rtP . L * rtP . R * 0.0 * t18
* 0.0 * t23 * t31 * 2.0 ) + rtP . R * 0.0 * t18 * t19 * 0.0 * t27 * rtP . w )
+ rtP . R * 0.0 * t18 * 0.0 * t23 * t28 * rtP . w ) - rtP . R * 0.0 * t18 *
t21 * 0.0 * t31 * rtP . w ) - rtP . L * rtP . R * 0.0 * 0.0 * t4 * t18 * 0.0
* 0.0 * t26 * 2.0 ) + rtP . L * rtP . R * 0.0 * 0.0 * t18 * 0.0 * t21 * 0.0 *
t31 * 2.0 ) - rtP . R * 0.0 * 0.0 * t4 * t18 * 0.0 * 0.0 * t27 * rtP . w ) -
rtP . R * 0.0 * 0.0 * t18 * 0.0 * 0.0 * t23 * t31 * rtP . w ) * t77 ;
nn5hyolh34 [ 11 ] = ( ( ( ( ( ( 0.0 * t4 * t14 * 0.0 + ( t4 * t28 - t14 * t19
) ) - 0.0 * t4 * 0.0 * t31 ) + 0.0 * t19 * 0.0 * t28 ) - 0.0 * t19 * 0.0 *
t25 ) + 0.0 * t4 * 0.0 * 0.0 * t25 ) - 0.0 * t19 * 0.0 * 0.0 * t31 ) * ( rtP
. R * t18 * t77 ) * - 2.0 ; nn5hyolh34 [ 12 ] = 0.0 ; nn5hyolh34 [ 13 ] = 0.0
; nn5hyolh34 [ 14 ] = ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( t106 *
rtP . w + t107 * rtP . w ) - t9 * t10 * t106 * 2.0 ) - t9 * t10 * t107 * 2.0
) + rtP . L * t4 * t14 * t18 * t23 * 2.0 ) + rtP . L * t4 * t18 * t21 * t28 *
2.0 ) - rtP . L * t14 * t18 * t19 * t21 * 2.0 ) + rtP . L * t18 * t19 * t23 *
t28 * 2.0 ) + t4 * t14 * t18 * t21 * rtP . w ) - t4 * t18 * t23 * t28 * rtP .
w ) + t14 * t18 * t19 * t23 * rtP . w ) + t18 * t19 * t21 * t28 * rtP . w ) +
0.0 * t18 * 0.0 * t27 * t106 * rtP . w ) + 0.0 * t18 * 0.0 * t27 * t107 * rtP
. w ) + rtP . L * 0.0 * t18 * 0.0 * t26 * t106 * 2.0 ) + rtP . L * 0.0 * t18
* 0.0 * t26 * t107 * 2.0 ) + rtP . L * 0.0 * t4 * t18 * 0.0 * t23 * t25 * 2.0
) - rtP . L * 0.0 * t4 * t18 * t21 * 0.0 * t31 * 2.0 ) - rtP . L * 0.0 * t18
* t19 * t21 * 0.0 * t25 * 2.0 ) - rtP . L * 0.0 * t18 * t19 * 0.0 * t23 * t31
* 2.0 ) + 0.0 * t4 * t18 * t21 * 0.0 * t25 * rtP . w ) + 0.0 * t4 * t18 * 0.0
* t23 * t31 * rtP . w ) + 0.0 * t18 * t19 * 0.0 * t23 * t25 * rtP . w ) - 0.0
* t18 * t19 * t21 * 0.0 * t31 * rtP . w ) * t77 ; nn5hyolh34 [ 15 ] = 1.0 ;
memset ( & nn5hyolh34 [ 16 ] , 0 , 9U * sizeof ( real_T ) ) ; nn5hyolh34 [ 25
] = rtP . L * t7 ; nn5hyolh34 [ 26 ] = 1.0 ; t2 = rtB . hkbmt1bwgv [ 3 ] +
rtB . hkbmt1bwgv [ 2 ] ; t3 = muDoubleScalarCos ( t2 ) ; t4 =
muDoubleScalarTan ( rtB . hkbmt1bwgv [ 3 ] ) ; t5 = 1.0 / ( t4 + 3.0 ) ; t9 =
muDoubleScalarAtan ( t4 * t5 * 3.0 ) + rtB . hkbmt1bwgv [ 2 ] ; t10 =
muDoubleScalarCos ( t9 ) ; t13 = t4 * t4 ; t15 = ( t4 * 6.0 + t13 * 10.0 ) +
9.0 ; t17 = muDoubleScalarSqrt ( 1.0 / ( ( t4 + 3.0 ) * ( t4 + 3.0 ) ) * t15
) ; t18 = muDoubleScalarSin ( t2 ) ; t20 = muDoubleScalarCos ( rtB .
hkbmt1bwgv [ 3 ] ) ; t21 = muDoubleScalarSin ( rtB . hkbmt1bwgv [ 3 ] ) ; t23
= rtB . hkbmt1bwgv [ 4 ] + rtB . hkbmt1bwgv [ 2 ] ; t24 = muDoubleScalarSin (
t23 ) ; t25 = muDoubleScalarCos ( rtB . hkbmt1bwgv [ 4 ] ) ; t26 =
muDoubleScalarSin ( rtB . hkbmt1bwgv [ 4 ] ) ; t27 = muDoubleScalarSin ( t9 )
; t28 = t10 * t10 ; t29 = t27 * t27 ; t30 = muDoubleScalarCos ( t23 ) ; t100
= 1.0 / ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( t3 * t10 * 3.0 + t3
* t27 * 18.0 ) + t18 * t27 * 3.0 ) + t3 * t4 * t27 * 9.0 ) + t17 * t20 * t28
* 3.0 ) + t17 * t21 * t28 * 18.0 ) + t17 * t20 * t29 * 3.0 ) + t17 * t21 *
t29 * 18.0 ) + t4 * t17 * t20 * t28 ) + t4 * t17 * t21 * t28 * 6.0 ) + t4 *
t17 * t20 * t29 ) + t4 * t17 * t21 * t29 * 6.0 ) + 0.0 * t3 * t10 * 0.0 *
18.0 ) + 0.0 * t10 * t18 * 0.0 * 3.0 ) + 0.0 * t18 * 0.0 * t27 * 18.0 ) + 0.0
* t3 * t4 * t10 * 0.0 * 9.0 ) + 0.0 * t3 * t4 * 0.0 * t27 * 17.0 ) + 0.0 * t4
* t18 * 0.0 * t27 * 9.0 ) + 0.0 * t17 * 0.0 * t21 * t28 * 3.0 ) + 0.0 * t17 *
0.0 * t21 * t29 * 3.0 ) + 0.0 * t3 * t10 * t17 * 0.0 * t26 * 3.0 ) + 0.0 *
t10 * t17 * t21 * 0.0 * t30 * 18.0 ) + 0.0 * t10 * t17 * t20 * 0.0 * t24 *
3.0 ) + 0.0 * t3 * t17 * 0.0 * t25 * t27 * 18.0 ) + 0.0 * t10 * t17 * t21 *
0.0 * t24 * 18.0 ) + 0.0 * t3 * t17 * 0.0 * t26 * t27 * 3.0 ) + 0.0 * t17 *
t18 * 0.0 * t25 * t27 * 18.0 ) + 0.0 * t17 * t20 * 0.0 * t24 * t27 * 3.0 ) +
0.0 * t17 * t18 * 0.0 * t26 * t27 * 3.0 ) + 0.0 * t17 * t21 * 0.0 * t24 * t27
* 18.0 ) + 0.0 * t3 * 0.0 * 0.0 * t24 * 15.0 ) + 0.0 * t4 * t17 * 0.0 * t21 *
t28 ) + 0.0 * t4 * t17 * 0.0 * t21 * t29 ) + 0.0 * t3 * t10 * t17 * 0.0 * t25
* 18.0 ) + 0.0 * t10 * t17 * t20 * 0.0 * t30 * 3.0 ) + 0.0 * t3 * t4 * 0.0 *
0.0 * t24 * 26.0 ) + 0.0 * t3 * t4 * t10 * t17 * 0.0 * t25 * 6.0 ) + 0.0 * t4
* t10 * t17 * t20 * 0.0 * t30 ) + 0.0 * t3 * t4 * t10 * t17 * 0.0 * t26 ) +
0.0 * t4 * t10 * t17 * t21 * 0.0 * t30 * 6.0 ) + 0.0 * t4 * t10 * t17 * t20 *
0.0 * t24 ) + 0.0 * t3 * t4 * t17 * 0.0 * t25 * t27 * 6.0 ) + 0.0 * t4 * t10
* t17 * t21 * 0.0 * t24 * 6.0 ) + 0.0 * t3 * t4 * t17 * 0.0 * t26 * t27 ) +
0.0 * t4 * t17 * t18 * 0.0 * t25 * t27 * 6.0 ) + 0.0 * t4 * t17 * t20 * 0.0 *
t24 * t27 ) + 0.0 * t4 * t17 * t18 * 0.0 * t26 * t27 ) + 0.0 * t4 * t17 * t21
* 0.0 * t24 * t27 * 6.0 ) + 0.0 * t3 * t10 * t17 * 0.0 * 0.0 * t25 * 18.0 ) +
0.0 * t3 * t10 * t17 * 0.0 * 0.0 * t26 * 3.0 ) + 0.0 * t10 * t17 * 0.0 * t21
* 0.0 * t30 * 3.0 ) + 0.0 * t10 * t17 * t18 * 0.0 * 0.0 * t25 * 18.0 ) + 0.0
* t17 * 0.0 * t20 * 0.0 * t27 * t30 * 18.0 ) + 0.0 * t10 * t17 * t18 * 0.0 *
0.0 * t26 * 3.0 ) + 0.0 * t10 * t17 * 0.0 * t21 * 0.0 * t24 * 3.0 ) + 0.0 *
t17 * t18 * 0.0 * 0.0 * t25 * t27 * 18.0 ) + 0.0 * t17 * t18 * 0.0 * 0.0 *
t26 * t27 * 3.0 ) + 0.0 * t17 * 0.0 * t21 * 0.0 * t24 * t27 * 3.0 ) + 0.0 *
t3 * t4 * t10 * t17 * 0.0 * 0.0 * t25 * 6.0 ) + 0.0 * t3 * t4 * t10 * t17 *
0.0 * 0.0 * t26 ) + 0.0 * t4 * t10 * t17 * 0.0 * t21 * 0.0 * t30 ) + 0.0 * t4
* t10 * t17 * t18 * 0.0 * 0.0 * t25 * 6.0 ) + 0.0 * t4 * t17 * 0.0 * t20 *
0.0 * t27 * t30 * 6.0 ) + 0.0 * t4 * t10 * t17 * t18 * 0.0 * 0.0 * t26 ) +
0.0 * t4 * t10 * t17 * 0.0 * t21 * 0.0 * t24 ) + 0.0 * t4 * t17 * t18 * 0.0 *
0.0 * t25 * t27 * 6.0 ) + 0.0 * t4 * t17 * t18 * 0.0 * 0.0 * t26 * t27 ) +
0.0 * t4 * t17 * 0.0 * t21 * 0.0 * t24 * t27 ) - t10 * t18 * 18.0 ) - t3 * t4
* t10 * 17.0 ) - t4 * t10 * t18 * 9.0 ) - t4 * t18 * t27 * 17.0 ) - 0.0 * t3
* 0.0 * t27 * 3.0 ) - 0.0 * t3 * 0.0 * t30 * 15.0 ) - 0.0 * t18 * 0.0 * t24 *
15.0 ) - 0.0 * t4 * t10 * t18 * 0.0 * 17.0 ) - 0.0 * t3 * t4 * 0.0 * t30 *
26.0 ) - 0.0 * t17 * 0.0 * t20 * t28 * 18.0 ) - 0.0 * t17 * 0.0 * t20 * t29 *
18.0 ) - 0.0 * t4 * t18 * 0.0 * t24 * 26.0 ) - 0.0 * t10 * t17 * t18 * 0.0 *
t25 * 18.0 ) - 0.0 * t17 * t20 * 0.0 * t27 * t30 * 3.0 ) - 0.0 * t10 * t17 *
t18 * 0.0 * t26 * 3.0 ) - 0.0 * t17 * t21 * 0.0 * t27 * t30 * 18.0 ) - 0.0 *
t18 * 0.0 * 0.0 * t30 * 15.0 ) - 0.0 * t4 * t17 * 0.0 * t20 * t28 * 6.0 ) -
0.0 * t4 * t17 * 0.0 * t20 * t29 * 6.0 ) - 0.0 * t4 * t18 * 0.0 * 0.0 * t30 *
26.0 ) - 0.0 * t4 * t10 * t17 * t18 * 0.0 * t25 * 6.0 ) - 0.0 * t4 * t17 *
t20 * 0.0 * t27 * t30 ) - 0.0 * t4 * t10 * t17 * t18 * 0.0 * t26 ) - 0.0 * t4
* t17 * t21 * 0.0 * t27 * t30 * 6.0 ) - 0.0 * t10 * t17 * 0.0 * t20 * 0.0 *
t30 * 18.0 ) - 0.0 * t10 * t17 * 0.0 * t20 * 0.0 * t24 * 18.0 ) - 0.0 * t3 *
t17 * 0.0 * 0.0 * t25 * t27 * 18.0 ) - 0.0 * t3 * t17 * 0.0 * 0.0 * t26 * t27
* 3.0 ) - 0.0 * t17 * 0.0 * t21 * 0.0 * t27 * t30 * 3.0 ) - 0.0 * t17 * 0.0 *
t20 * 0.0 * t24 * t27 * 18.0 ) - 0.0 * t4 * t10 * t17 * 0.0 * t20 * 0.0 * t30
* 6.0 ) - 0.0 * t4 * t10 * t17 * 0.0 * t20 * 0.0 * t24 * 6.0 ) - 0.0 * t3 *
t4 * t17 * 0.0 * 0.0 * t25 * t27 * 6.0 ) - 0.0 * t3 * t4 * t17 * 0.0 * 0.0 *
t26 * t27 ) - 0.0 * t4 * t17 * 0.0 * t21 * 0.0 * t27 * t30 ) - 0.0 * t4 * t17
* 0.0 * t20 * 0.0 * t24 * t27 * 6.0 ) ; t137 = t18 * t18 ; t77 = t3 * t3 ;
ehrq52oenb [ 0 ] = ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( t3 *
3.0 - t3 * t4 * 17.0 ) + 0.0 * t18 * 0.0 * 3.0 ) + t10 * t17 * t20 * 3.0 ) +
t10 * t17 * t21 * 18.0 ) - 0.0 * t4 * t18 * 0.0 * 17.0 ) + t4 * t10 * t17 *
t20 ) + t4 * t10 * t17 * t21 * 6.0 ) - 0.0 * t10 * t17 * 0.0 * t20 * 18.0 ) +
0.0 * t10 * t17 * 0.0 * t21 * 3.0 ) + 0.0 * t3 * t17 * 0.0 * t25 * 18.0 ) +
0.0 * t3 * t17 * 0.0 * t26 * 3.0 ) + 0.0 * t17 * t20 * 0.0 * t24 * 3.0 ) +
0.0 * t17 * t21 * 0.0 * t24 * 18.0 ) - 0.0 * t4 * t10 * t17 * 0.0 * t20 * 6.0
) + 0.0 * t4 * t10 * t17 * 0.0 * t21 ) + 0.0 * t3 * t4 * t17 * 0.0 * t25 *
6.0 ) + 0.0 * t3 * t4 * t17 * 0.0 * t26 ) + 0.0 * t4 * t17 * t20 * 0.0 * t24
) + 0.0 * t4 * t17 * t21 * 0.0 * t24 * 6.0 ) + 0.0 * t17 * t18 * 0.0 * 0.0 *
t25 * 18.0 ) + 0.0 * t17 * t18 * 0.0 * 0.0 * t26 * 3.0 ) - 0.0 * t17 * 0.0 *
t20 * 0.0 * t24 * 18.0 ) + 0.0 * t17 * 0.0 * t21 * 0.0 * t24 * 3.0 ) + 0.0 *
t4 * t17 * t18 * 0.0 * 0.0 * t25 * 6.0 ) + 0.0 * t4 * t17 * t18 * 0.0 * 0.0 *
t26 ) - 0.0 * t4 * t17 * 0.0 * t20 * 0.0 * t24 * 6.0 ) + 0.0 * t4 * t17 * 0.0
* t21 * 0.0 * t24 ) * ( rtB . hkbmt1bwgv [ 10 ] * t100 ) *
0.34424620000000011 ; ehrq52oenb [ 1 ] = ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( t18 * 3.0 - t4 * t18 * 17.0 ) - 0.0 * t3 * 0.0 * 3.0 ) +
t17 * t20 * t27 * 3.0 ) + t17 * t21 * t27 * 18.0 ) + 0.0 * t3 * t4 * 0.0 *
17.0 ) + t4 * t17 * t20 * t27 ) + t4 * t17 * t21 * t27 * 6.0 ) - 0.0 * t17 *
0.0 * t20 * t27 * 18.0 ) + 0.0 * t17 * t18 * 0.0 * t25 * 18.0 ) + 0.0 * t17 *
0.0 * t21 * t27 * 3.0 ) + 0.0 * t17 * t18 * 0.0 * t26 * 3.0 ) - 0.0 * t17 *
t20 * 0.0 * t30 * 3.0 ) - 0.0 * t17 * t21 * 0.0 * t30 * 18.0 ) - 0.0 * t4 *
t17 * 0.0 * t20 * t27 * 6.0 ) + 0.0 * t4 * t17 * t18 * 0.0 * t25 * 6.0 ) +
0.0 * t4 * t17 * 0.0 * t21 * t27 ) + 0.0 * t4 * t17 * t18 * 0.0 * t26 ) - 0.0
* t4 * t17 * t20 * 0.0 * t30 ) - 0.0 * t4 * t17 * t21 * 0.0 * t30 * 6.0 ) -
0.0 * t3 * t17 * 0.0 * 0.0 * t25 * 18.0 ) - 0.0 * t3 * t17 * 0.0 * 0.0 * t26
* 3.0 ) + 0.0 * t17 * 0.0 * t20 * 0.0 * t30 * 18.0 ) - 0.0 * t17 * 0.0 * t21
* 0.0 * t30 * 3.0 ) - 0.0 * t3 * t4 * t17 * 0.0 * 0.0 * t25 * 6.0 ) - 0.0 *
t3 * t4 * t17 * 0.0 * 0.0 * t26 ) + 0.0 * t4 * t17 * 0.0 * t20 * 0.0 * t30 *
6.0 ) - 0.0 * t4 * t17 * 0.0 * t21 * 0.0 * t30 ) * ( rtB . hkbmt1bwgv [ 10 ]
* t100 ) * 0.34424620000000011 ; ehrq52oenb [ 2 ] = ( ( ( ( ( ( ( t10 * t18 -
t3 * t27 ) - 0.0 * t3 * t10 * 0.0 ) + 0.0 * t3 * 0.0 * t30 ) - 0.0 * t18 *
0.0 * t27 ) + 0.0 * t18 * 0.0 * t24 ) - 0.0 * t3 * 0.0 * 0.0 * t24 ) + 0.0 *
t18 * 0.0 * 0.0 * t30 ) * ( ( t4 + 3.0 ) * rtB . hkbmt1bwgv [ 10 ] * t17 *
t100 ) * 0.45899493333333341 ; ehrq52oenb [ 3 ] = rtB . hkbmt1bwgv [ 9 ] *
t15 * 0.1111111111111111 / ( t13 + 1.0 ) ; ehrq52oenb [ 4 ] = rtB .
hkbmt1bwgv [ 9 ] ; ehrq52oenb [ 5 ] = ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( t137 * 3.0 + t77 * 3.0 ) - t4 *
t137 * 17.0 ) - t4 * t77 * 17.0 ) + t3 * t10 * t17 * t20 * 3.0 ) + t3 * t10 *
t17 * t21 * 18.0 ) - t10 * t17 * t18 * t20 * 18.0 ) + t10 * t17 * t18 * t21 *
3.0 ) + t3 * t17 * t20 * t27 * 18.0 ) - t3 * t17 * t21 * t27 * 3.0 ) + t17 *
t18 * t20 * t27 * 3.0 ) + t17 * t18 * t21 * t27 * 18.0 ) + 0.0 * t17 * 0.0 *
t25 * t137 * 18.0 ) + 0.0 * t17 * 0.0 * t25 * t77 * 18.0 ) + 0.0 * t17 * 0.0
* t26 * t137 * 3.0 ) + 0.0 * t17 * 0.0 * t26 * t77 * 3.0 ) + t3 * t4 * t10 *
t17 * t20 ) + t3 * t4 * t10 * t17 * t21 * 6.0 ) - t4 * t10 * t17 * t18 * t20
* 6.0 ) + t4 * t10 * t17 * t18 * t21 ) + t3 * t4 * t17 * t20 * t27 * 6.0 ) -
t3 * t4 * t17 * t21 * t27 ) + t4 * t17 * t18 * t20 * t27 ) + t4 * t17 * t18 *
t21 * t27 * 6.0 ) + 0.0 * t3 * t17 * t20 * 0.0 * t24 * 3.0 ) + 0.0 * t3 * t17
* t21 * 0.0 * t24 * 18.0 ) - 0.0 * t3 * t17 * t20 * 0.0 * t30 * 18.0 ) + 0.0
* t3 * t17 * t21 * 0.0 * t30 * 3.0 ) - 0.0 * t17 * t18 * t20 * 0.0 * t24 *
18.0 ) + 0.0 * t17 * t18 * t21 * 0.0 * t24 * 3.0 ) - 0.0 * t17 * t18 * t20 *
0.0 * t30 * 3.0 ) - 0.0 * t17 * t18 * t21 * 0.0 * t30 * 18.0 ) + 0.0 * t4 *
t17 * 0.0 * t25 * t137 * 6.0 ) + 0.0 * t4 * t17 * 0.0 * t25 * t77 * 6.0 ) +
0.0 * t4 * t17 * 0.0 * t26 * t137 ) + 0.0 * t4 * t17 * 0.0 * t26 * t77 ) +
0.0 * t3 * t4 * t17 * t20 * 0.0 * t24 ) + 0.0 * t3 * t4 * t17 * t21 * 0.0 *
t24 * 6.0 ) - 0.0 * t3 * t4 * t17 * t20 * 0.0 * t30 * 6.0 ) + 0.0 * t3 * t4 *
t17 * t21 * 0.0 * t30 ) - 0.0 * t4 * t17 * t18 * t20 * 0.0 * t24 * 6.0 ) +
0.0 * t4 * t17 * t18 * t21 * 0.0 * t24 ) - 0.0 * t4 * t17 * t18 * t20 * 0.0 *
t30 ) - 0.0 * t4 * t17 * t18 * t21 * 0.0 * t30 * 6.0 ) * ( rtB . hkbmt1bwgv [
10 ] * t100 ) ; ehrq52oenb [ 6 ] = rtB . hkbmt1bwgv [ 10 ] ; ehrq52oenb [ 7 ]
= rtB . hkbmt1bwgv [ 11 ] * t5 * 3.0 ; ehrq52oenb [ 8 ] = rtB . hkbmt1bwgv [
11 ] ; t2 = muDoubleScalarSin ( rtB . hkbmt1bwgv [ 2 ] ) ; t3 =
muDoubleScalarCos ( rtB . hkbmt1bwgv [ 2 ] ) ; t4 = ehrq52oenb [ 2 ] *
ehrq52oenb [ 2 ] ; t5 = ehrq52oenb [ 3 ] * ehrq52oenb [ 3 ] ; t7 =
muDoubleScalarSin ( rtB . hkbmt1bwgv [ 3 ] + rtB . hkbmt1bwgv [ 2 ] ) ; t8 =
rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 9 ] ; t10 = muDoubleScalarSin (
rtB . hkbmt1bwgv [ 4 ] + rtB . hkbmt1bwgv [ 2 ] ) ; t11 = rtB . hkbmt1bwgv [
6 ] + rtB . hkbmt1bwgv [ 2 ] ; t12 = muDoubleScalarCos ( t11 ) ; t13 = rtB .
hkbmt1bwgv [ 8 ] + rtB . hkbmt1bwgv [ 2 ] ; t14 = muDoubleScalarCos ( t13 ) ;
t15 = rtB . hkbmt1bwgv [ 11 ] * rtB . hkbmt1bwgv [ 11 ] ; t16 =
muDoubleScalarSin ( t11 ) ; t17 = ehrq52oenb [ 7 ] * ehrq52oenb [ 7 ] ; t18 =
muDoubleScalarSin ( t13 ) ; t19 = rtB . hkbmt1bwgv [ 2 ] * 2.0 ; t20 = rtB .
hkbmt1bwgv [ 3 ] * 2.0 ; t21 = ( rtB . hkbmt1bwgv [ 5 ] + t19 ) + t20 ; t22 =
muDoubleScalarCos ( t21 ) ; t23 = ehrq52oenb [ 5 ] * ehrq52oenb [ 5 ] ; t24 =
rtB . hkbmt1bwgv [ 4 ] * 2.0 ; t25 = ( rtB . hkbmt1bwgv [ 7 ] + t19 ) + t24 ;
t26 = muDoubleScalarCos ( t25 ) ; t27 = rtB . hkbmt1bwgv [ 10 ] * rtB .
hkbmt1bwgv [ 10 ] ; t28 = muDoubleScalarSin ( t21 ) ; t29 = muDoubleScalarSin
( t25 ) ; t30 = rtB . hkbmt1bwgv [ 6 ] - t19 ; t31 = muDoubleScalarCos ( t30
) ; t32 = rtB . hkbmt1bwgv [ 6 ] + t19 ; t33 = muDoubleScalarCos ( t32 ) ;
t34 = rtB . hkbmt1bwgv [ 8 ] - t19 ; t35 = muDoubleScalarCos ( t34 ) ; t36 =
rtB . hkbmt1bwgv [ 8 ] + t19 ; t37 = muDoubleScalarCos ( t36 ) ; t38 = rtB .
hkbmt1bwgv [ 6 ] - rtB . hkbmt1bwgv [ 2 ] ; t9 = muDoubleScalarCos ( t38 ) ;
t40 = rtB . hkbmt1bwgv [ 6 ] * 3.0 ; t41 = t40 + rtB . hkbmt1bwgv [ 2 ] ; t42
= muDoubleScalarCos ( t41 ) ; t43 = rtB . hkbmt1bwgv [ 8 ] - rtB . hkbmt1bwgv
[ 2 ] ; t11 = muDoubleScalarCos ( t43 ) ; t45 = rtB . hkbmt1bwgv [ 8 ] * 3.0
; t46 = t45 + rtB . hkbmt1bwgv [ 2 ] ; t47 = muDoubleScalarCos ( t46 ) ; t48
= ( rtB . hkbmt1bwgv [ 3 ] + rtB . hkbmt1bwgv [ 5 ] ) + rtB . hkbmt1bwgv [ 2
] ; t49 = muDoubleScalarCos ( t48 ) ; t50 = ( rtB . hkbmt1bwgv [ 4 ] + rtB .
hkbmt1bwgv [ 7 ] ) + rtB . hkbmt1bwgv [ 2 ] ; t51 = muDoubleScalarCos ( t50 )
; t52 = muDoubleScalarSin ( t30 ) ; t53 = muDoubleScalarSin ( t32 ) ; t54 =
rtB . hkbmt1bwgv [ 6 ] * 2.0 ; t55 = t54 + rtB . hkbmt1bwgv [ 2 ] ; t56 =
muDoubleScalarSin ( t38 ) ; t57 = muDoubleScalarSin ( t41 ) ; t58 =
muDoubleScalarSin ( t34 ) ; t59 = muDoubleScalarSin ( t36 ) ; t60 = rtB .
hkbmt1bwgv [ 8 ] * 2.0 ; t61 = t60 + rtB . hkbmt1bwgv [ 2 ] ; t62 =
muDoubleScalarSin ( t43 ) ; t63 = muDoubleScalarSin ( t46 ) ; t64 = rtB .
hkbmt1bwgv [ 6 ] * 4.0 ; t65 = t64 + rtB . hkbmt1bwgv [ 2 ] ; t66 =
muDoubleScalarSin ( t65 ) ; t67 = rtB . hkbmt1bwgv [ 8 ] * 4.0 ; t68 = t67 +
rtB . hkbmt1bwgv [ 2 ] ; t69 = muDoubleScalarSin ( t68 ) ; t70 =
muDoubleScalarSin ( t48 ) ; t71 = muDoubleScalarSin ( t50 ) ; t72 = ( - rtB .
hkbmt1bwgv [ 5 ] + t19 ) + t20 ; t73 = muDoubleScalarCos ( t72 ) ; t74 = rtB
. hkbmt1bwgv [ 5 ] * 2.0 ; t75 = ( t19 + t20 ) + t74 ; t76 =
muDoubleScalarCos ( t75 ) ; t77 = ( t19 + t20 ) - t74 ; t78 =
muDoubleScalarCos ( t77 ) ; t79 = rtB . hkbmt1bwgv [ 5 ] * 3.0 ; t80 = ( t19
+ t20 ) + t79 ; t81 = muDoubleScalarCos ( t80 ) ; t82 = ( - rtB . hkbmt1bwgv
[ 7 ] + t19 ) + t24 ; t83 = muDoubleScalarCos ( t82 ) ; t84 = rtB .
hkbmt1bwgv [ 7 ] * 2.0 ; t85 = ( t19 + t24 ) + t84 ; t86 = muDoubleScalarCos
( t85 ) ; t87 = ( t19 + t24 ) - t84 ; t88 = muDoubleScalarCos ( t87 ) ; t89 =
rtB . hkbmt1bwgv [ 7 ] * 3.0 ; t90 = ( t19 + t24 ) + t89 ; t91 =
muDoubleScalarCos ( t90 ) ; t92 = rtB . hkbmt1bwgv [ 5 ] * 4.0 ; t93 = ( t19
+ t20 ) + t92 ; t94 = ( t19 + t20 ) - t79 ; t95 = muDoubleScalarSin ( t77 ) ;
t96 = muDoubleScalarSin ( t75 ) ; t97 = ( t19 + t20 ) - t92 ; t98 =
muDoubleScalarSin ( t97 ) ; t99 = muDoubleScalarSin ( t93 ) ; t100 = rtB .
hkbmt1bwgv [ 7 ] * 4.0 ; t101 = ( t19 + t24 ) + t100 ; t102 = ( t19 + t24 ) -
t89 ; t103 = muDoubleScalarSin ( t87 ) ; t104 = muDoubleScalarSin ( t85 ) ;
t105 = ( t19 + t24 ) - t100 ; t106 = muDoubleScalarSin ( t105 ) ; t107 =
muDoubleScalarSin ( t101 ) ; t108 = muDoubleScalarCos ( t94 ) ; t109 =
muDoubleScalarCos ( t93 ) ; t110 = muDoubleScalarCos ( t102 ) ; t111 =
muDoubleScalarCos ( t101 ) ; t112 = muDoubleScalarSin ( t72 ) ; t113 =
muDoubleScalarSin ( t94 ) ; t114 = muDoubleScalarSin ( t80 ) ; t115 =
muDoubleScalarSin ( t82 ) ; t116 = muDoubleScalarSin ( t102 ) ; t117 =
muDoubleScalarSin ( t90 ) ; t118 = muDoubleScalarSin ( t19 ) ; t120 =
muDoubleScalarSin ( t19 + t20 ) ; t122 = muDoubleScalarSin ( t19 + t24 ) ;
t123 = - t19 + t54 ; t124 = muDoubleScalarCos ( t123 ) ; t125 = t19 + t54 ;
t13 = muDoubleScalarCos ( t125 ) ; t127 = - t19 + t60 ; t21 =
muDoubleScalarCos ( t127 ) ; t129 = t19 + t60 ; t130 = muDoubleScalarCos (
t129 ) ; t131 = t40 - rtB . hkbmt1bwgv [ 2 ] ; t132 = muDoubleScalarCos (
t131 ) ; t133 = - t19 + t40 ; t134 = muDoubleScalarCos ( t133 ) ; t135 = t19
+ t40 ; t136 = muDoubleScalarCos ( t135 ) ; t137 = t45 - rtB . hkbmt1bwgv [ 2
] ; t77 = muDoubleScalarCos ( t137 ) ; t139 = - t19 + t45 ; t140 =
muDoubleScalarCos ( t139 ) ; t141 = t19 + t45 ; t142 = muDoubleScalarCos (
t141 ) ; t143 = ( rtB . hkbmt1bwgv [ 3 ] - rtB . hkbmt1bwgv [ 5 ] ) + rtB .
hkbmt1bwgv [ 2 ] ; t144 = muDoubleScalarCos ( t143 ) ; t145 = ( rtB .
hkbmt1bwgv [ 3 ] - t79 ) + rtB . hkbmt1bwgv [ 2 ] ; t146 = muDoubleScalarCos
( t145 ) ; t147 = ( rtB . hkbmt1bwgv [ 3 ] + t79 ) + rtB . hkbmt1bwgv [ 2 ] ;
t148 = muDoubleScalarCos ( t147 ) ; t149 = ( rtB . hkbmt1bwgv [ 4 ] - rtB .
hkbmt1bwgv [ 7 ] ) + rtB . hkbmt1bwgv [ 2 ] ; t45 = muDoubleScalarCos ( t149
) ; t151 = ( rtB . hkbmt1bwgv [ 4 ] - t89 ) + rtB . hkbmt1bwgv [ 2 ] ; t25 =
muDoubleScalarCos ( t151 ) ; t153 = ( rtB . hkbmt1bwgv [ 4 ] + t89 ) + rtB .
hkbmt1bwgv [ 2 ] ; t30 = muDoubleScalarCos ( t153 ) ; t155 = ( rtB .
hkbmt1bwgv [ 3 ] - t92 ) + rtB . hkbmt1bwgv [ 2 ] ; t156 = ( rtB . hkbmt1bwgv
[ 3 ] + t92 ) + rtB . hkbmt1bwgv [ 2 ] ; t40 = muDoubleScalarSin ( t155 ) ;
t32 = muDoubleScalarSin ( t156 ) ; t159 = ( rtB . hkbmt1bwgv [ 4 ] - t100 ) +
rtB . hkbmt1bwgv [ 2 ] ; t160 = ( rtB . hkbmt1bwgv [ 4 ] + t100 ) + rtB .
hkbmt1bwgv [ 2 ] ; t34 = muDoubleScalarSin ( t159 ) ; t36 = muDoubleScalarSin
( t160 ) ; t38 = muDoubleScalarCos ( t155 ) ; t164 = muDoubleScalarCos ( t156
) ; t41 = muDoubleScalarCos ( t159 ) ; t166 = muDoubleScalarCos ( t160 ) ;
t43 = t54 - rtB . hkbmt1bwgv [ 2 ] ; t46 = muDoubleScalarSin ( t123 ) ; t125
= muDoubleScalarSin ( t125 ) ; t170 = muDoubleScalarSin ( t131 ) ; t133 =
muDoubleScalarSin ( t133 ) ; t172 = muDoubleScalarSin ( t135 ) ; t173 = t60 -
rtB . hkbmt1bwgv [ 2 ] ; t174 = muDoubleScalarSin ( t127 ) ; t175 =
muDoubleScalarSin ( t129 ) ; t137 = muDoubleScalarSin ( t137 ) ; t177 =
muDoubleScalarSin ( t139 ) ; t178 = muDoubleScalarSin ( t141 ) ; t179 = t64 -
rtB . hkbmt1bwgv [ 2 ] ; t180 = - t19 + t64 ; t181 = t19 + t64 ; t182 =
muDoubleScalarSin ( t179 ) ; t139 = muDoubleScalarSin ( t180 ) ; t123 =
muDoubleScalarSin ( t181 ) ; t185 = t67 - rtB . hkbmt1bwgv [ 2 ] ; t186 = -
t19 + t67 ; t160 = t19 + t67 ; t141 = muDoubleScalarSin ( t185 ) ; t127 =
muDoubleScalarSin ( t186 ) ; t131 = muDoubleScalarSin ( t160 ) ; t143 =
muDoubleScalarSin ( t143 ) ; t145 = muDoubleScalarSin ( t145 ) ; t147 =
muDoubleScalarSin ( t147 ) ; t194 = ( rtB . hkbmt1bwgv [ 3 ] - t74 ) + rtB .
hkbmt1bwgv [ 2 ] ; t195 = ( rtB . hkbmt1bwgv [ 3 ] + t74 ) + rtB . hkbmt1bwgv
[ 2 ] ; t129 = muDoubleScalarSin ( t149 ) ; t135 = muDoubleScalarSin ( t151 )
; t149 = muDoubleScalarSin ( t153 ) ; t199 = ( rtB . hkbmt1bwgv [ 4 ] - t84 )
+ rtB . hkbmt1bwgv [ 2 ] ; t200 = ( rtB . hkbmt1bwgv [ 4 ] + t84 ) + rtB .
hkbmt1bwgv [ 2 ] ; t65 = muDoubleScalarCos ( t65 ) ; t68 = muDoubleScalarCos
( t68 ) ; t153 = muDoubleScalarCos ( t97 ) ; t97 = muDoubleScalarCos ( t105 )
; t151 = muDoubleScalarSin ( t74 ) ; t105 = muDoubleScalarSin ( t92 ) ; t159
= muDoubleScalarSin ( t84 ) ; t156 = muDoubleScalarSin ( t100 ) ; t155 =
muDoubleScalarCos ( t74 ) ; t210 = muDoubleScalarCos ( t92 ) ; t211 =
muDoubleScalarCos ( t84 ) ; t212 = muDoubleScalarCos ( t100 ) ; t213 =
muDoubleScalarSin ( t54 ) ; t214 = muDoubleScalarSin ( t64 ) ; t215 =
muDoubleScalarSin ( t60 ) ; t216 = muDoubleScalarSin ( t67 ) ; t217 =
muDoubleScalarCos ( t179 ) ; t100 = muDoubleScalarCos ( t180 ) ; t219 =
muDoubleScalarCos ( t181 ) ; t220 = muDoubleScalarCos ( t185 ) ; t221 =
muDoubleScalarCos ( t186 ) ; t222 = muDoubleScalarCos ( t160 ) ; t223 = rtP .
Ii_11 * t5 * t7 * 0.125 ; t224 = rtP . Ii_11 * t4 * t7 * 0.125 ; t225 = rtP .
Ii_21 * t5 * t22 * 0.125 ; t226 = rtP . Ii_21 * t22 * t23 * 0.5 ; t227 = rtP
. Ii_31 * t22 * t23 * 0.125 ; t228 = rtP . Ii_32 * t5 * t28 * 0.375 ; t160 =
rtP . Ii_21 * t4 * t22 * 0.125 ; t230 = rtP . Ii_11 * t23 * t28 * 0.0625 ;
t231 = rtP . Ii_32 * t23 * t28 * 0.5 ; t232 = rtP . Ii_33 * t23 * t28 *
0.1875 ; t233 = rtP . Ii_32 * t4 * t28 * 0.375 ; t234 = rtP . Ii_21 * t5 *
t49 * 0.125 ; t74 = rtP . Ii_21 * t4 * t49 * 0.125 ; t92 = rtP . Ii_11 * t23
* t70 * 0.125 ; t84 = rtP . Ii_21 * t5 * t73 * 0.125 ; t186 = rtP . Ii_31 *
t5 * t109 * 0.0625 ; t185 = rtP . Ii_21 * t23 * t73 * 0.5 ; t181 = rtP .
Ii_21 * t23 * t78 * 0.5 ; t180 = rtP . Ii_21 * t23 * t76 * 0.5 ; t179 = rtP .
Ii_31 * t23 * t78 * 0.25 ; t48 = rtP . Ii_31 * t23 * t108 * 0.375 ; t50 = rtP
. Ii_22 * t5 * t95 * 0.125 ; t72 = rtP . Ii_22 * t5 * t96 * 0.125 ; t75 = rtP
. Ii_32 * t5 * t113 * 0.125 ; t80 = rtP . Ii_33 * t5 * t98 * 0.03125 ; t82 =
rtP . Ii_33 * t5 * t99 * 0.03125 ; t85 = rtP . Ii_21 * t4 * t73 * 0.125 ; t87
= rtP . Ii_31 * t4 * t78 * 0.125 ; t90 = rtP . Ii_31 * t4 * t109 * 0.0625 ;
t94 = rtP . Ii_11 * t23 * t112 * 0.0625 ; t93 = rtP . Ii_11 * t23 * t95 *
0.125 ; t101 = rtP . Ii_11 * t23 * t96 * 0.125 ; t102 = rtP . Ii_11 * t23 *
t113 * 0.1875 ; t256 = rtP . Ii_11 * t23 * t114 * 0.1875 ; t257 = rtP . Ii_32
* t23 * t96 * 0.5 ; t258 = rtP . Ii_33 * t23 * t112 * 0.1875 ; t259 = rtP .
Ii_22 * t4 * t95 * 0.125 ; t260 = rtP . Ii_22 * t4 * t96 * 0.125 ; t261 = rtP
. Ii_32 * t4 * t113 * 0.125 ; t262 = rtP . Ii_33 * t4 * t98 * 0.03125 ; t263
= rtP . Ii_33 * t4 * t99 * 0.03125 ; t264 = rtP . Ii_11 * t5 * t120 * 0.0625
; t265 = rtP . Ii_33 * t5 * t120 * 0.1875 ; t266 = rtP . Ii_21 * t5 * t144 *
0.125 ; t267 = rtP . Ii_31 * t5 * t164 * 0.125 ; t268 = rtP . Ii_11 * t23 *
t120 * 0.25 ; t269 = rtP . Ii_33 * t23 * t120 * 0.25 ; t271 = rtP . Ii_21 *
t23 * muDoubleScalarCos ( t194 ) * 0.5 ; t273 = rtP . Ii_21 * t23 *
muDoubleScalarCos ( t195 ) * 0.5 ; t274 = rtP . Ii_31 * t23 * t144 * 0.25 ;
t275 = rtP . Ii_31 * t23 * t146 * 0.75 ; t276 = rtP . Ii_11 * t4 * t120 *
0.0625 ; t277 = rtP . Ii_33 * t4 * t120 * 0.1875 ; t278 = rtP . Ii_32 * t5 *
t143 * 0.125 ; t279 = rtP . Ii_32 * t5 * t145 * 0.125 ; t280 = rtP . Ii_33 *
t5 * t40 * 0.0625 ; t281 = rtP . Ii_33 * t5 * t32 * 0.0625 ; t282 = rtP .
Ii_21 * t4 * t144 * 0.125 ; t283 = rtP . Ii_31 * t4 * t164 * 0.125 ; t284 =
rtP . Ii_11 * t23 * t143 * 0.125 ; t285 = rtP . Ii_11 * t23 * t145 * 0.375 ;
t286 = rtP . Ii_11 * t23 * t147 * 0.375 ; t287 = muDoubleScalarSin ( t194 ) ;
t194 = rtP . Ii_32 * t23 * muDoubleScalarSin ( t195 ) * 0.5 ; t290 = rtP .
Ii_32 * t4 * t143 * 0.125 ; t291 = rtP . Ii_32 * t4 * t145 * 0.125 ; t292 =
rtP . Ii_33 * t4 * t40 * 0.0625 ; t293 = rtP . Ii_33 * t4 * t32 * 0.0625 ;
t294 = rtP . Ii_11 * ehrq52oenb [ 5 ] * t40 * ehrq52oenb [ 2 ] * 0.5 ; t295 =
rtP . Ii_33 * ehrq52oenb [ 5 ] * t32 * ehrq52oenb [ 2 ] * 0.5 ; t296 = rtP .
Ii_11 * ehrq52oenb [ 3 ] * t7 * ehrq52oenb [ 2 ] * 0.25 ; t297 = rtP . Ii_21
* ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t22 * 0.125 ; t298 = rtP . Ii_21 *
ehrq52oenb [ 3 ] * t22 * ehrq52oenb [ 2 ] * 0.25 ; t299 = rtP . Ii_32 *
ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t28 * 0.375 ; t300 = rtP . Ii_21 *
ehrq52oenb [ 5 ] * t22 * ehrq52oenb [ 2 ] * 0.125 ; t301 = rtP . Ii_32 *
ehrq52oenb [ 3 ] * t28 * ehrq52oenb [ 2 ] * 0.75 ; t302 = rtP . Ii_32 *
ehrq52oenb [ 5 ] * t28 * ehrq52oenb [ 2 ] * 0.375 ; t303 = rtP . Ii_21 *
ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t49 * 0.25 ; t304 = rtP . Ii_21 *
ehrq52oenb [ 3 ] * t49 * ehrq52oenb [ 2 ] * 0.25 ; t22 = rtP . Ii_21 *
ehrq52oenb [ 5 ] * t49 * ehrq52oenb [ 2 ] * 0.25 ; t195 = rtP . Ii_21 *
ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t108 * 0.375 ; t307 = rtP . Ii_31 *
ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t153 * 0.25 ; t308 = rtP . Ii_31 *
ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t109 * 0.25 ; t309 = rtP . Ii_21 *
ehrq52oenb [ 3 ] * t73 * ehrq52oenb [ 2 ] * 0.25 ; t310 = rtP . Ii_31 *
ehrq52oenb [ 3 ] * t78 * ehrq52oenb [ 2 ] * 0.25 ; t311 = rtP . Ii_31 *
ehrq52oenb [ 3 ] * t109 * ehrq52oenb [ 2 ] * 0.125 ; t312 = rtP . Ii_31 *
ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t155 * 0.5 ; t313 = rtP . Ii_31 *
ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t210 * 1.5 ; t314 = rtP . Ii_11 *
ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t98 * 0.125 ; t315 = rtP . Ii_22 *
ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t96 * 0.25 ; t316 = rtP . Ii_32 *
ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t112 * 0.375 ; t317 = rtP . Ii_33 *
ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t95 * 0.25 ; t318 = rtP . Ii_33 *
ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t99 * 0.125 ; t319 = rtP . Ii_21 *
ehrq52oenb [ 5 ] * t108 * ehrq52oenb [ 2 ] * 0.375 ; t320 = rtP . Ii_31 *
ehrq52oenb [ 5 ] * t153 * ehrq52oenb [ 2 ] * 0.25 ; t109 = rtP . Ii_31 *
ehrq52oenb [ 5 ] * t109 * ehrq52oenb [ 2 ] * 0.25 ; t322 = rtP . Ii_22 *
ehrq52oenb [ 3 ] * t95 * ehrq52oenb [ 2 ] * 0.25 ; t323 = rtP . Ii_22 *
ehrq52oenb [ 3 ] * t96 * ehrq52oenb [ 2 ] * 0.25 ; t324 = rtP . Ii_32 *
ehrq52oenb [ 3 ] * t113 * ehrq52oenb [ 2 ] * 0.25 ; t325 = rtP . Ii_33 *
ehrq52oenb [ 3 ] * t98 * ehrq52oenb [ 2 ] * 0.0625 ; t326 = rtP . Ii_33 *
ehrq52oenb [ 3 ] * t99 * ehrq52oenb [ 2 ] * 0.0625 ; t327 = rtP . Ii_33 *
ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t151 * 0.5 ; t328 = rtP . Ii_33 *
ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t105 * 0.75 ; t329 = rtP . Ii_31 *
ehrq52oenb [ 5 ] * t155 * ehrq52oenb [ 2 ] * 0.5 ; t330 = rtP . Ii_31 *
ehrq52oenb [ 5 ] * t210 * ehrq52oenb [ 2 ] * 1.5 ; t331 = rtP . Ii_11 *
ehrq52oenb [ 5 ] * t98 * ehrq52oenb [ 2 ] * 0.125 ; t332 = rtP . Ii_22 *
ehrq52oenb [ 5 ] * t96 * ehrq52oenb [ 2 ] * 0.25 ; t333 = rtP . Ii_32 *
ehrq52oenb [ 5 ] * t112 * ehrq52oenb [ 2 ] * 0.375 ; t334 = rtP . Ii_33 *
ehrq52oenb [ 5 ] * t95 * ehrq52oenb [ 2 ] * 0.25 ; t335 = rtP . Ii_33 *
ehrq52oenb [ 5 ] * t99 * ehrq52oenb [ 2 ] * 0.125 ; t336 = rtP . Ii_33 *
ehrq52oenb [ 5 ] * t151 * ehrq52oenb [ 2 ] * 0.5 ; t337 = rtP . Ii_33 *
ehrq52oenb [ 5 ] * t105 * ehrq52oenb [ 2 ] * 0.75 ; t338 = rtP . Ii_21 *
ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t146 * 0.75 ; t339 = rtP . Ii_31 *
ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t38 ; t340 = rtP . Ii_31 * ehrq52oenb [
3 ] * ehrq52oenb [ 5 ] * t164 ; t341 = rtP . Ii_11 * ehrq52oenb [ 3 ] * t120
* ehrq52oenb [ 2 ] * 0.125 ; t342 = rtP . Ii_33 * ehrq52oenb [ 3 ] * t120 *
ehrq52oenb [ 2 ] * 0.375 ; t343 = rtP . Ii_21 * ehrq52oenb [ 3 ] * t144 *
ehrq52oenb [ 2 ] * 0.25 ; t344 = rtP . Ii_31 * ehrq52oenb [ 3 ] * t164 *
ehrq52oenb [ 2 ] * 0.25 ; t345 = rtP . Ii_11 * ehrq52oenb [ 3 ] * ehrq52oenb
[ 5 ] * t40 * 0.5 ; t346 = rtP . Ii_33 * ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ]
* t32 * 0.5 ; t347 = rtP . Ii_21 * ehrq52oenb [ 5 ] * t146 * ehrq52oenb [ 2 ]
* 0.75 ; t348 = rtP . Ii_31 * ehrq52oenb [ 5 ] * t38 * ehrq52oenb [ 2 ] ;
t349 = rtP . Ii_31 * ehrq52oenb [ 5 ] * t164 * ehrq52oenb [ 2 ] ; t350 = rtP
. Ii_32 * ehrq52oenb [ 3 ] * t143 * ehrq52oenb [ 2 ] * 0.25 ; t351 = rtP .
Ii_32 * ehrq52oenb [ 3 ] * t145 * ehrq52oenb [ 2 ] * 0.25 ; t352 = rtP .
Ii_33 * ehrq52oenb [ 3 ] * t40 * ehrq52oenb [ 2 ] * 0.125 ; t353 = rtP .
Ii_33 * ehrq52oenb [ 3 ] * t32 * ehrq52oenb [ 2 ] * 0.125 ; t354 = rtP .
Io_11 * t8 * t10 * 0.125 ; t355 = rtP . Io_11 * t4 * t10 * 0.125 ; t356 = rtP
. Io_21 * t8 * t26 * 0.125 ; t357 = rtP . Io_21 * t26 * t27 * 0.5 ; t358 =
rtP . Io_31 * t26 * t27 * 0.125 ; t359 = rtP . Io_32 * t8 * t29 * 0.375 ;
t360 = rtP . Io_21 * t4 * t26 * 0.125 ; t361 = rtP . Io_11 * t27 * t29 *
0.0625 ; t362 = rtP . Io_32 * t27 * t29 * 0.5 ; t363 = rtP . Io_33 * t27 *
t29 * 0.1875 ; t364 = rtP . Io_32 * t4 * t29 * 0.375 ; t365 = rtP . Io_21 *
t8 * t51 * 0.125 ; t366 = rtP . Io_21 * t4 * t51 * 0.125 ; t164 = rtP . Io_11
* t27 * t71 * 0.125 ; t368 = rtP . Io_21 * t8 * t83 * 0.125 ; t369 = rtP .
Io_31 * t8 * t111 * 0.0625 ; t370 = rtP . Io_21 * t27 * t83 * 0.5 ; t371 =
rtP . Io_21 * t27 * t88 * 0.5 ; t372 = rtP . Io_21 * t27 * t86 * 0.5 ; t373 =
rtP . Io_31 * t27 * t88 * 0.25 ; t374 = rtP . Io_31 * t27 * t110 * 0.375 ;
t375 = rtP . Io_22 * t8 * t103 * 0.125 ; t376 = rtP . Io_22 * t8 * t104 *
0.125 ; t377 = rtP . Io_32 * t8 * t116 * 0.125 ; t378 = rtP . Io_33 * t8 *
t106 * 0.03125 ; t379 = rtP . Io_33 * t8 * t107 * 0.03125 ; t380 = rtP .
Io_21 * t4 * t83 * 0.125 ; t381 = rtP . Io_31 * t4 * t88 * 0.125 ; t382 = rtP
. Io_31 * t4 * t111 * 0.0625 ; t383 = rtP . Io_11 * t27 * t115 * 0.0625 ;
t384 = rtP . Io_11 * t27 * t103 * 0.125 ; t385 = rtP . Io_11 * t27 * t104 *
0.125 ; t386 = rtP . Io_11 * t27 * t116 * 0.1875 ; t387 = rtP . Io_11 * t27 *
t117 * 0.1875 ; t388 = rtP . Io_32 * t27 * t104 * 0.5 ; t389 = rtP . Io_33 *
t27 * t115 * 0.1875 ; t390 = rtP . Io_22 * t4 * t103 * 0.125 ; t391 = rtP .
Io_22 * t4 * t104 * 0.125 ; t392 = rtP . Io_32 * t4 * t116 * 0.125 ; t393 =
rtP . Io_33 * t4 * t106 * 0.03125 ; t394 = rtP . Io_33 * t4 * t107 * 0.03125
; t395 = rtP . Io_11 * t8 * t122 * 0.0625 ; t396 = rtP . Io_33 * t8 * t122 *
0.1875 ; t397 = rtP . Io_21 * t8 * t45 * 0.125 ; t398 = rtP . Io_31 * t8 *
t166 * 0.125 ; t399 = rtP . Io_11 * t27 * t122 * 0.25 ; t400 = rtP . Io_33 *
t27 * t122 * 0.25 ; t402 = rtP . Io_21 * t27 * muDoubleScalarCos ( t199 ) *
0.5 ; t404 = rtP . Io_21 * t27 * muDoubleScalarCos ( t200 ) * 0.5 ; t405 =
rtP . Io_31 * t27 * t45 * 0.25 ; t406 = rtP . Io_31 * t27 * t25 * 0.75 ; t407
= rtP . Io_11 * t4 * t122 * 0.0625 ; t408 = rtP . Io_33 * t4 * t122 * 0.1875
; t409 = rtP . Io_32 * t8 * t129 * 0.125 ; t410 = rtP . Io_32 * t8 * t135 *
0.125 ; t411 = rtP . Io_33 * t8 * t34 * 0.0625 ; t412 = rtP . Io_33 * t8 *
t36 * 0.0625 ; t413 = rtP . Io_21 * t4 * t45 * 0.125 ; t414 = rtP . Io_31 *
t4 * t166 * 0.125 ; t415 = rtP . Io_11 * t27 * t129 * 0.125 ; t416 = rtP .
Io_11 * t27 * t135 * 0.375 ; t417 = rtP . Io_11 * t27 * t149 * 0.375 ; t199 =
muDoubleScalarSin ( t199 ) ; t200 = rtP . Io_32 * t27 * muDoubleScalarSin (
t200 ) * 0.5 ; t421 = rtP . Io_32 * t4 * t129 * 0.125 ; t422 = rtP . Io_32 *
t4 * t135 * 0.125 ; t423 = rtP . Io_33 * t4 * t34 * 0.0625 ; t424 = rtP .
Io_33 * t4 * t36 * 0.0625 ; t425 = rtP . Io_11 * rtB . hkbmt1bwgv [ 10 ] *
t34 * ehrq52oenb [ 2 ] * 0.5 ; t426 = rtP . Io_33 * rtB . hkbmt1bwgv [ 10 ] *
t36 * ehrq52oenb [ 2 ] * 0.5 ; t427 = rtP . Io_11 * rtB . hkbmt1bwgv [ 9 ] *
t10 * ehrq52oenb [ 2 ] * 0.25 ; t428 = rtP . Io_21 * rtB . hkbmt1bwgv [ 9 ] *
rtB . hkbmt1bwgv [ 10 ] * t26 * 0.125 ; t429 = rtP . Io_21 * rtB . hkbmt1bwgv
[ 9 ] * t26 * ehrq52oenb [ 2 ] * 0.25 ; t430 = rtP . Io_32 * rtB . hkbmt1bwgv
[ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t29 * 0.375 ; t431 = rtP . Io_21 * rtB .
hkbmt1bwgv [ 10 ] * t26 * ehrq52oenb [ 2 ] * 0.125 ; t432 = rtP . Io_32 * rtB
. hkbmt1bwgv [ 9 ] * t29 * ehrq52oenb [ 2 ] * 0.75 ; t433 = rtP . Io_32 * rtB
. hkbmt1bwgv [ 10 ] * t29 * ehrq52oenb [ 2 ] * 0.375 ; t434 = rtP . Io_21 *
rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t51 * 0.25 ; t435 = rtP .
Io_21 * rtB . hkbmt1bwgv [ 9 ] * t51 * ehrq52oenb [ 2 ] * 0.25 ; t436 = rtP .
Io_21 * rtB . hkbmt1bwgv [ 10 ] * t51 * ehrq52oenb [ 2 ] * 0.25 ; t437 = rtP
. Io_21 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t110 * 0.375 ;
t438 = rtP . Io_31 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t97 *
0.25 ; t439 = rtP . Io_31 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ]
* t111 * 0.25 ; t440 = rtP . Io_21 * rtB . hkbmt1bwgv [ 9 ] * t83 *
ehrq52oenb [ 2 ] * 0.25 ; t441 = rtP . Io_31 * rtB . hkbmt1bwgv [ 9 ] * t88 *
ehrq52oenb [ 2 ] * 0.25 ; t442 = rtP . Io_31 * rtB . hkbmt1bwgv [ 9 ] * t111
* ehrq52oenb [ 2 ] * 0.125 ; t443 = rtP . Io_31 * rtB . hkbmt1bwgv [ 9 ] *
rtB . hkbmt1bwgv [ 10 ] * t211 * 0.5 ; t444 = rtP . Io_31 * rtB . hkbmt1bwgv
[ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t212 * 1.5 ; t445 = rtP . Io_11 * rtB .
hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t106 * 0.125 ; t446 = rtP .
Io_22 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t104 * 0.25 ; t447
= rtP . Io_32 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t115 *
0.375 ; t448 = rtP . Io_33 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ]
* t103 * 0.25 ; t449 = rtP . Io_33 * rtB . hkbmt1bwgv [ 9 ] * rtB .
hkbmt1bwgv [ 10 ] * t107 * 0.125 ; t450 = rtP . Io_21 * rtB . hkbmt1bwgv [ 10
] * t110 * ehrq52oenb [ 2 ] * 0.375 ; t451 = rtP . Io_31 * rtB . hkbmt1bwgv [
10 ] * t97 * ehrq52oenb [ 2 ] * 0.25 ; t111 = rtP . Io_31 * rtB . hkbmt1bwgv
[ 10 ] * t111 * ehrq52oenb [ 2 ] * 0.25 ; t453 = rtP . Io_22 * rtB .
hkbmt1bwgv [ 9 ] * t103 * ehrq52oenb [ 2 ] * 0.25 ; t454 = rtP . Io_22 * rtB
. hkbmt1bwgv [ 9 ] * t104 * ehrq52oenb [ 2 ] * 0.25 ; t455 = rtP . Io_32 *
rtB . hkbmt1bwgv [ 9 ] * t116 * ehrq52oenb [ 2 ] * 0.25 ; t456 = rtP . Io_33
* rtB . hkbmt1bwgv [ 9 ] * t106 * ehrq52oenb [ 2 ] * 0.0625 ; t26 = rtP .
Io_33 * rtB . hkbmt1bwgv [ 9 ] * t107 * ehrq52oenb [ 2 ] * 0.0625 ; t458 =
rtP . Io_33 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t159 * 0.5 ;
t459 = rtP . Io_33 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t156
* 0.75 ; t460 = rtP . Io_31 * rtB . hkbmt1bwgv [ 10 ] * t211 * ehrq52oenb [ 2
] * 0.5 ; t461 = rtP . Io_31 * rtB . hkbmt1bwgv [ 10 ] * t212 * ehrq52oenb [
2 ] * 1.5 ; t462 = rtP . Io_11 * rtB . hkbmt1bwgv [ 10 ] * t106 * ehrq52oenb
[ 2 ] * 0.125 ; t463 = rtP . Io_22 * rtB . hkbmt1bwgv [ 10 ] * t104 *
ehrq52oenb [ 2 ] * 0.25 ; t464 = rtP . Io_32 * rtB . hkbmt1bwgv [ 10 ] * t115
* ehrq52oenb [ 2 ] * 0.375 ; t465 = rtP . Io_33 * rtB . hkbmt1bwgv [ 10 ] *
t103 * ehrq52oenb [ 2 ] * 0.25 ; t466 = rtP . Io_33 * rtB . hkbmt1bwgv [ 10 ]
* t107 * ehrq52oenb [ 2 ] * 0.125 ; t467 = rtP . Io_33 * rtB . hkbmt1bwgv [
10 ] * t159 * ehrq52oenb [ 2 ] * 0.5 ; t468 = rtP . Io_33 * rtB . hkbmt1bwgv
[ 10 ] * t156 * ehrq52oenb [ 2 ] * 0.75 ; t469 = rtP . Io_21 * rtB .
hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t25 * 0.75 ; t470 = rtP . Io_31
* rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t41 ; t471 = rtP . Io_31
* rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t166 ; t472 = rtP .
Io_11 * rtB . hkbmt1bwgv [ 9 ] * t122 * ehrq52oenb [ 2 ] * 0.125 ; t473 = rtP
. Io_33 * rtB . hkbmt1bwgv [ 9 ] * t122 * ehrq52oenb [ 2 ] * 0.375 ; t474 =
rtP . Io_21 * rtB . hkbmt1bwgv [ 9 ] * t45 * ehrq52oenb [ 2 ] * 0.25 ; t475 =
rtP . Io_31 * rtB . hkbmt1bwgv [ 9 ] * t166 * ehrq52oenb [ 2 ] * 0.25 ; t476
= rtP . Io_11 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t34 * 0.5
; t477 = rtP . Io_33 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t36
* 0.5 ; t478 = rtP . Io_21 * rtB . hkbmt1bwgv [ 10 ] * t25 * ehrq52oenb [ 2 ]
* 0.75 ; t479 = rtP . Io_31 * rtB . hkbmt1bwgv [ 10 ] * t41 * ehrq52oenb [ 2
] ; t166 = rtP . Io_31 * rtB . hkbmt1bwgv [ 10 ] * t166 * ehrq52oenb [ 2 ] ;
t481 = rtP . Io_32 * rtB . hkbmt1bwgv [ 9 ] * t129 * ehrq52oenb [ 2 ] * 0.25
; t482 = rtP . Io_32 * rtB . hkbmt1bwgv [ 9 ] * t135 * ehrq52oenb [ 2 ] *
0.25 ; t483 = rtP . Io_33 * rtB . hkbmt1bwgv [ 9 ] * t34 * ehrq52oenb [ 2 ] *
0.125 ; t484 = rtP . Io_33 * rtB . hkbmt1bwgv [ 9 ] * t36 * ehrq52oenb [ 2 ]
* 0.125 ; t485 = muDoubleScalarCos ( rtB . hkbmt1bwgv [ 3 ] ) ; t486 =
muDoubleScalarSin ( rtB . hkbmt1bwgv [ 3 ] ) ; t487 = muDoubleScalarCos ( t20
) ; t488 = muDoubleScalarSin ( t20 ) ; t489 = muDoubleScalarCos ( t19 ) ;
t490 = muDoubleScalarSin ( rtB . hkbmt1bwgv [ 5 ] ) ; t491 =
muDoubleScalarCos ( rtB . hkbmt1bwgv [ 5 ] ) ; t492 = muDoubleScalarCos ( t79
) ; t79 = muDoubleScalarSin ( t79 ) ; t494 = muDoubleScalarCos ( rtB .
hkbmt1bwgv [ 4 ] ) ; t495 = muDoubleScalarSin ( rtB . hkbmt1bwgv [ 4 ] ) ;
t496 = muDoubleScalarCos ( t24 ) ; t497 = muDoubleScalarSin ( t24 ) ; t498 =
muDoubleScalarSin ( rtB . hkbmt1bwgv [ 7 ] ) ; t499 = muDoubleScalarCos ( rtB
. hkbmt1bwgv [ 7 ] ) ; t500 = muDoubleScalarCos ( t89 ) ; t89 =
muDoubleScalarSin ( t89 ) ; t502 = muDoubleScalarCos ( rtB . hkbmt1bwgv [ 8 ]
) ; t503 = t502 * t502 ; t504 = muDoubleScalarSin ( rtB . hkbmt1bwgv [ 8 ] )
; t505 = t504 * t504 ; t506 = t2 * t2 ; t507 = t503 * t503 ; t508 = t3 * t3 ;
t509 = t505 * t505 ; t510 = muDoubleScalarCos ( rtB . hkbmt1bwgv [ 6 ] ) ;
t511 = t510 * t510 ; t512 = muDoubleScalarSin ( rtB . hkbmt1bwgv [ 6 ] ) ;
t513 = t512 * t512 ; t514 = t511 * t511 ; t515 = t513 * t513 ; owi2j0naiy [ 0
] = ( ( ( ( ( ( rtP . L * rtP . mi * t2 * 2.0 + rtP . L * rtP . mo * t2 * 2.0
) + rtP . Lc * rtP . mc * t2 * 2.0 ) - rtP . mi * t3 * rtP . w ) - rtP . ml *
t3 * rtP . w ) + rtP . mo * t3 * rtP . w ) + rtP . mr * t3 * rtP . w ) * t4 *
- 0.5 ; owi2j0naiy [ 1 ] = ( ( ( ( ( ( rtP . L * rtP . mi * t3 * 2.0 + rtP .
L * rtP . mo * t3 * 2.0 ) + rtP . Lc * rtP . mc * t3 * 2.0 ) + rtP . mi * t2
* rtP . w ) + rtP . ml * t2 * rtP . w ) - rtP . mo * t2 * rtP . w ) - rtP .
mr * t2 * rtP . w ) * t4 * 0.5 ; owi2j0naiy [ 2 ] = ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( rtP . Ir_21 * ehrq52oenb [ 7 ] * t77 *
ehrq52oenb [ 2 ] * 0.75 + ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( rtP . Ir_11 * t17 * t175 * 0.125 +
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( rtP . Il_32 * t15 * t125 * 0.5 + ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( rtP . Ir_32
* t17 * muDoubleScalarSin ( t173 ) * 0.5 + ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( t223 + t224 ) + t225 ) + t226 ) + t227 ) + t228 ) + t160 ) + t230 )
+ t231 ) + t232 ) + t233 ) + t234 ) + t74 ) + t92 ) + t84 ) + t186 ) + t185 )
+ t181 ) + t180 ) + t179 ) + t48 ) + t50 ) + t72 ) + t75 ) + t80 ) + t82 ) +
t85 ) + t87 ) + t90 ) + t94 ) + t93 ) + t101 ) + t102 ) + t256 ) + t257 ) +
t258 ) + t259 ) + t260 ) + t261 ) + t262 ) + t263 ) + t264 ) + t265 ) + t266
) + t267 ) + t268 ) + t269 ) + t271 ) + t273 ) + t274 ) + t275 ) + t276 ) +
t277 ) + t278 ) + t279 ) + t280 ) + t281 ) + t282 ) + t283 ) + t284 ) + t285
) + t286 ) + t194 ) + t290 ) + t291 ) + t292 ) + t293 ) + t294 ) + t295 ) +
t296 ) + t297 ) + t298 ) + t299 ) + t300 ) + t301 ) + t302 ) + t303 ) + t304
) + t22 ) + t195 ) + t307 ) + t308 ) + t309 ) + t310 ) + t311 ) + t312 ) +
t313 ) + t314 ) + t315 ) + t316 ) + t317 ) + t318 ) + t319 ) + t320 ) + t109
) + t322 ) + t323 ) + t324 ) + t325 ) + t326 ) + t327 ) + t328 ) + t329 ) +
t330 ) + t331 ) + t332 ) + t333 ) + t334 ) + t335 ) + t336 ) + t337 ) + t338
) + t339 ) + t340 ) + t341 ) + t342 ) + t343 ) + t344 ) + t345 ) + t346 ) +
t347 ) + t348 ) + t349 ) + t350 ) + t351 ) + t352 ) + t353 ) + t354 ) + t355
) + t356 ) + t357 ) + t358 ) + t359 ) + t360 ) + t361 ) + t362 ) + t363 ) +
t364 ) + t365 ) + t366 ) + t164 ) + t368 ) + t369 ) + t370 ) + t371 ) + t372
) + t373 ) + t374 ) + t375 ) + t376 ) + t377 ) + t378 ) + t379 ) + t380 ) +
t381 ) + t382 ) + t383 ) + t384 ) + t385 ) + t386 ) + t387 ) + t388 ) + t389
) + t390 ) + t391 ) + t392 ) + t393 ) + t394 ) + t395 ) + t396 ) + t397 ) +
t398 ) + t399 ) + t400 ) + t402 ) + t404 ) + t405 ) + t406 ) + t407 ) + t408
) + t409 ) + t410 ) + t411 ) + t412 ) + t413 ) + t414 ) + t415 ) + t416 ) +
t417 ) + t200 ) + t421 ) + t422 ) + t423 ) + t424 ) + t425 ) + t426 ) + t427
) + t428 ) + t429 ) + t430 ) + t431 ) + t432 ) + t433 ) + t434 ) + t435 ) +
t436 ) + t437 ) + t438 ) + t439 ) + t440 ) + t441 ) + t442 ) + t443 ) + t444
) + t445 ) + t446 ) + t447 ) + t448 ) + t449 ) + t450 ) + t451 ) + t111 ) +
t453 ) + t454 ) + t455 ) + t456 ) + t26 ) + t458 ) + t459 ) + t460 ) + t461 )
+ t462 ) + t463 ) + t464 ) + t465 ) + t466 ) + t467 ) + t468 ) + t469 ) +
t470 ) + t471 ) + t472 ) + t473 ) + t474 ) + t475 ) + t476 ) + t477 ) + t478
) + t479 ) + t166 ) + t481 ) + t482 ) + t483 ) + t484 ) + rtP . Il_32 * t15 *
muDoubleScalarSin ( t55 ) * 0.5 ) + rtP . Il_32 * t15 * muDoubleScalarSin (
t43 ) * 0.5 ) + rtP . Ir_32 * t17 * muDoubleScalarSin ( t61 ) * 0.5 ) ) - rtP
. Ii_33 * t4 * t7 * 0.125 ) - rtP . Ii_33 * t5 * t7 * 0.125 ) - rtP . Ii_22 *
t23 * t28 * 0.25 ) - rtP . Ii_31 * t23 * t49 * 0.25 ) - rtP . Ii_21 * t4 *
t81 * 0.125 ) - rtP . Ii_32 * t4 * t70 * 0.125 ) - rtP . Ii_21 * t5 * t81 *
0.125 ) - rtP . Ii_32 * t5 * t70 * 0.125 ) - rtP . Ii_31 * t4 * t76 * 0.125 )
- rtP . Ii_31 * t5 * t76 * 0.125 ) - rtP . Ii_11 * t4 * t98 * 0.03125 ) - rtP
. Ii_11 * t4 * t99 * 0.03125 ) - rtP . Ii_11 * t5 * t98 * 0.03125 ) - rtP .
Ii_11 * t5 * t99 * 0.03125 ) - rtP . Ii_33 * t23 * t70 * 0.125 ) - rtP .
Ii_31 * t23 * t73 * 0.125 ) - rtP . Ii_31 * t23 * t76 * 0.25 ) - rtP . Ii_33
* t4 * t95 * 0.125 ) - rtP . Ii_21 * t4 * t108 * 0.125 ) - rtP . Ii_33 * t4 *
t96 * 0.125 ) - rtP . Ii_33 * t5 * t95 * 0.125 ) - rtP . Ii_33 * t5 * t96 *
0.125 ) - rtP . Ii_31 * t23 * t81 * 0.375 ) - rtP . Ii_22 * t4 * t120 * 0.25
) - rtP . Ii_22 * t5 * t120 * 0.25 ) - rtP . Ii_32 * t4 * t112 * 0.375 ) -
rtP . Ii_32 * t5 * t112 * 0.375 ) - rtP . Ii_32 * t4 * t114 * 0.125 ) - rtP .
Ii_32 * t23 * t95 * 0.5 ) - rtP . Ii_32 * t5 * t114 * 0.125 ) - rtP . Ii_33 *
t23 * t95 * 0.125 ) - rtP . Ii_33 * t23 * t96 * 0.125 ) - rtP . Ii_22 * t23 *
t112 * 0.25 ) - rtP . Ii_22 * t23 * t120 * 0.5 ) - rtP . Ii_32 * t23 * t112 *
0.5 ) - rtP . Ii_33 * t23 * t113 * 0.1875 ) - rtP . Ii_33 * t23 * t114 *
0.1875 ) - rtP . Ii_21 * t4 * t146 * 0.125 ) - rtP . Ii_11 * t4 * t40 *
0.0625 ) - rtP . Ii_21 * t5 * t146 * 0.125 ) - rtP . Ii_11 * t4 * t32 *
0.0625 ) - rtP . Ii_11 * t5 * t40 * 0.0625 ) - rtP . Ii_21 * t4 * t148 *
0.125 ) - rtP . Ii_11 * t5 * t32 * 0.0625 ) - rtP . Ii_21 * t5 * t148 * 0.125
) - rtP . Ii_31 * t4 * t38 * 0.125 ) - rtP . Ii_31 * t5 * t38 * 0.125 ) - rtP
. Ii_31 * t23 * t148 * 0.75 ) - rtP . Ii_32 * t4 * t147 * 0.125 ) - rtP .
Ii_32 * t5 * t147 * 0.125 ) - rtP . Ii_31 * t4 * t153 * 0.0625 ) - rtP .
Ii_33 * t23 * t143 * 0.125 ) - rtP . Ii_33 * t23 * t145 * 0.375 ) - rtP .
Ii_33 * t23 * t147 * 0.375 ) - rtP . Ii_32 * t23 * t287 * 0.5 ) + rtP . Il_11
* t2 * t4 * 0.125 ) + rtP . Il_21 * t4 * t12 * 0.125 ) - rtP . Il_33 * t2 *
t4 * 0.125 ) + rtP . Il_11 * t15 * t16 * 0.125 ) - rtP . Il_32 * t4 * t16 *
0.125 ) + rtP . Il_21 * t4 * t31 * 0.125 ) + rtP . Il_21 * t4 * t33 * 0.125 )
- rtP . Il_31 * t12 * t15 * 0.25 ) + rtP . Il_21 * t4 * t9 * 0.125 ) - rtP .
Il_33 * t15 * t16 * 0.125 ) - rtP . Il_21 * t4 * t42 * 0.125 ) + rtP . Il_21
* t15 * t31 * 0.5 ) + rtP . Il_21 * t15 * t33 * 0.5 ) - rtP . Il_31 * t15 *
t31 * 0.125 ) - rtP . Il_11 * t15 * t52 * 0.0625 ) + rtP . Il_11 * t15 * t53
* 0.0625 ) + rtP . Il_31 * t15 * t33 * 0.125 ) - rtP . Il_11 * t4 * t66 *
0.0625 ) - rtP . Il_11 * t15 * t56 * 0.125 ) + rtP . Il_11 * t15 * t57 *
0.375 ) + rtP . Il_31 * t15 * t9 * 0.25 ) - rtP . Il_31 * t15 * t42 * 0.75 )
+ rtP . Il_32 * t4 * t52 * 0.375 ) + rtP . Il_22 * t15 * t52 * 0.25 ) + rtP .
Il_32 * t4 * t53 * 0.375 ) - rtP . Il_22 * t15 * t53 * 0.25 ) - rtP . Il_32 *
t4 * t56 * 0.125 ) - rtP . Il_32 * t4 * t57 * 0.125 ) + rtP . Il_32 * t15 *
t52 * 0.5 ) + rtP . Il_32 * t15 * t53 * 0.5 ) - rtP . Il_33 * t15 * t52 *
0.1875 ) + rtP . Il_33 * t15 * t53 * 0.1875 ) + rtP . Il_33 * t4 * t66 *
0.0625 ) + rtP . Il_33 * t15 * t56 * 0.125 ) - rtP . Il_33 * t15 * t57 *
0.375 ) + rtP . Il_11 * t4 * t118 * 0.0625 ) + rtP . Il_11 * t15 * t118 *
0.25 ) - rtP . Il_22 * t4 * t118 * 0.25 ) - rtP . Il_22 * t15 * t118 * 0.5 )
+ rtP . Il_33 * t4 * t118 * 0.1875 ) - rtP . Il_21 * t4 * t132 * 0.125 ) -
rtP . Il_21 * t4 * t134 * 0.125 ) + rtP . Il_31 * t4 * t124 * 0.125 ) + rtP .
Il_21 * t15 * t124 * 0.5 ) - rtP . Il_21 * t4 * t136 * 0.125 ) - rtP . Il_31
* t4 * t13 * 0.125 ) + rtP . Il_21 * t15 * t13 * 0.5 ) + rtP . Il_33 * t15 *
t118 * 0.25 ) + rtP . Il_31 * t15 * t124 * 0.25 ) - rtP . Il_31 * t15 * t13 *
0.25 ) + rtP . Il_31 * t15 * t132 * 0.75 ) + rtP . Il_31 * t15 * t134 * 0.375
) - rtP . Il_31 * t15 * t136 * 0.375 ) - rtP . Il_11 * t15 * t46 * 0.125 ) -
rtP . Il_22 * t4 * t46 * 0.125 ) + rtP . Il_11 * t15 * t125 * 0.125 ) + rtP .
Il_22 * t4 * t125 * 0.125 ) - rtP . Il_11 * t15 * t170 * 0.375 ) + rtP .
Il_11 * t4 * t182 * 0.0625 ) - rtP . Il_11 * t15 * t133 * 0.1875 ) + rtP .
Il_11 * t4 * t139 * 0.03125 ) + rtP . Il_11 * t15 * t172 * 0.1875 ) - rtP .
Il_11 * t4 * t123 * 0.03125 ) + rtP . Il_33 * t4 * t46 * 0.125 ) - rtP .
Il_32 * t4 * t170 * 0.125 ) - rtP . Il_33 * t4 * t125 * 0.125 ) - rtP . Il_32
* t4 * t133 * 0.125 ) - rtP . Il_32 * t4 * t172 * 0.125 ) + rtP . Il_32 * t15
* t46 * 0.5 ) ) + rtP . Il_33 * t15 * t46 * 0.125 ) - rtP . Il_33 * t15 *
t125 * 0.125 ) + rtP . Il_33 * t15 * t170 * 0.375 ) - rtP . Il_33 * t4 * t182
* 0.0625 ) + rtP . Il_33 * t15 * t133 * 0.1875 ) - rtP . Il_33 * t4 * t139 *
0.03125 ) - rtP . Il_33 * t15 * t172 * 0.1875 ) + rtP . Il_33 * t4 * t123 *
0.03125 ) + rtP . Il_31 * t4 * t65 * 0.125 ) - rtP . Il_31 * t4 * t217 *
0.125 ) - rtP . Il_31 * t4 * t100 * 0.0625 ) + rtP . Il_31 * t4 * t219 *
0.0625 ) - rtP . Io_33 * t4 * t10 * 0.125 ) - rtP . Io_33 * t8 * t10 * 0.125
) - rtP . Io_22 * t27 * t29 * 0.25 ) - rtP . Io_32 * t4 * t71 * 0.125 ) - rtP
. Io_31 * t27 * t51 * 0.25 ) - rtP . Io_32 * t8 * t71 * 0.125 ) - rtP . Io_21
* t4 * t91 * 0.125 ) - rtP . Io_21 * t8 * t91 * 0.125 ) - rtP . Io_11 * t4 *
t106 * 0.03125 ) - rtP . Io_31 * t4 * t86 * 0.125 ) - rtP . Io_11 * t4 * t107
* 0.03125 ) - rtP . Io_11 * t8 * t106 * 0.03125 ) - rtP . Io_31 * t8 * t86 *
0.125 ) - rtP . Io_11 * t8 * t107 * 0.03125 ) - rtP . Io_33 * t27 * t71 *
0.125 ) - rtP . Io_21 * t4 * t110 * 0.125 ) - rtP . Io_33 * t4 * t103 * 0.125
) - rtP . Io_31 * t27 * t83 * 0.125 ) - rtP . Io_33 * t4 * t104 * 0.125 ) -
rtP . Io_31 * t27 * t86 * 0.25 ) - rtP . Io_33 * t8 * t103 * 0.125 ) - rtP .
Io_33 * t8 * t104 * 0.125 ) - rtP . Io_22 * t4 * t122 * 0.25 ) - rtP . Io_31
* t27 * t91 * 0.375 ) - rtP . Io_32 * t4 * t115 * 0.375 ) - rtP . Io_22 * t8
* t122 * 0.25 ) - rtP . Io_32 * t4 * t117 * 0.125 ) - rtP . Io_32 * t8 * t115
* 0.375 ) - rtP . Io_32 * t8 * t117 * 0.125 ) - rtP . Io_32 * t27 * t103 *
0.5 ) - rtP . Io_33 * t27 * t103 * 0.125 ) - rtP . Io_22 * t27 * t115 * 0.25
) - rtP . Io_33 * t27 * t104 * 0.125 ) - rtP . Io_22 * t27 * t122 * 0.5 ) -
rtP . Io_32 * t27 * t115 * 0.5 ) - rtP . Io_11 * t4 * t34 * 0.0625 ) - rtP .
Io_33 * t27 * t116 * 0.1875 ) - rtP . Io_11 * t4 * t36 * 0.0625 ) - rtP .
Io_21 * t4 * t25 * 0.125 ) - rtP . Io_33 * t27 * t117 * 0.1875 ) - rtP .
Io_21 * t4 * t30 * 0.125 ) - rtP . Io_11 * t8 * t34 * 0.0625 ) - rtP . Io_11
* t8 * t36 * 0.0625 ) - rtP . Io_21 * t8 * t25 * 0.125 ) - rtP . Io_21 * t8 *
t30 * 0.125 ) - rtP . Io_31 * t4 * t41 * 0.125 ) - rtP . Io_31 * t8 * t41 *
0.125 ) - rtP . Io_31 * t27 * t30 * 0.75 ) - rtP . Io_32 * t4 * t149 * 0.125
) - rtP . Io_32 * t8 * t149 * 0.125 ) - rtP . Io_31 * t4 * t97 * 0.0625 ) -
rtP . Io_33 * t27 * t129 * 0.125 ) - rtP . Io_33 * t27 * t135 * 0.375 ) - rtP
. Io_33 * t27 * t149 * 0.375 ) - rtP . Io_32 * t27 * t199 * 0.5 ) + rtP .
Ir_11 * t2 * t4 * 0.125 ) + rtP . Ir_21 * t4 * t14 * 0.125 ) - rtP . Ir_33 *
t2 * t4 * 0.125 ) + rtP . Ir_11 * t17 * t18 * 0.125 ) - rtP . Ir_32 * t4 *
t18 * 0.125 ) + rtP . Ir_21 * t4 * t35 * 0.125 ) + rtP . Ir_21 * t4 * t37 *
0.125 ) - rtP . Ir_31 * t14 * t17 * 0.25 ) - rtP . Ir_33 * t17 * t18 * 0.125
) + rtP . Ir_21 * t4 * t11 * 0.125 ) - rtP . Ir_21 * t4 * t47 * 0.125 ) + rtP
. Ir_21 * t17 * t35 * 0.5 ) + rtP . Ir_21 * t17 * t37 * 0.5 ) - rtP . Ir_31 *
t17 * t35 * 0.125 ) - rtP . Ir_11 * t4 * t69 * 0.0625 ) + rtP . Ir_31 * t17 *
t37 * 0.125 ) - rtP . Ir_11 * t17 * t58 * 0.0625 ) + rtP . Ir_11 * t17 * t59
* 0.0625 ) - rtP . Ir_11 * t17 * t62 * 0.125 ) + rtP . Ir_11 * t17 * t63 *
0.375 ) + rtP . Ir_31 * t17 * t11 * 0.25 ) + rtP . Ir_32 * t4 * t58 * 0.375 )
- rtP . Ir_31 * t17 * t47 * 0.75 ) + rtP . Ir_32 * t4 * t59 * 0.375 ) + rtP .
Ir_22 * t17 * t58 * 0.25 ) - rtP . Ir_22 * t17 * t59 * 0.25 ) - rtP . Ir_32 *
t4 * t62 * 0.125 ) - rtP . Ir_32 * t4 * t63 * 0.125 ) + rtP . Ir_33 * t4 *
t69 * 0.0625 ) + rtP . Ir_32 * t17 * t58 * 0.5 ) + rtP . Ir_32 * t17 * t59 *
0.5 ) - rtP . Ir_33 * t17 * t58 * 0.1875 ) + rtP . Ir_33 * t17 * t59 * 0.1875
) + rtP . Ir_33 * t17 * t62 * 0.125 ) - rtP . Ir_33 * t17 * t63 * 0.375 ) +
rtP . Ir_11 * t4 * t118 * 0.0625 ) - rtP . Ir_22 * t4 * t118 * 0.25 ) + rtP .
Ir_11 * t17 * t118 * 0.25 ) + rtP . Ir_33 * t4 * t118 * 0.1875 ) - rtP .
Ir_22 * t17 * t118 * 0.5 ) - rtP . Ir_21 * t4 * t77 * 0.125 ) + rtP . Ir_31 *
t4 * t21 * 0.125 ) - rtP . Ir_21 * t4 * t140 * 0.125 ) - rtP . Ir_31 * t4 *
t130 * 0.125 ) + rtP . Ir_21 * t17 * t21 * 0.5 ) - rtP . Ir_21 * t4 * t142 *
0.125 ) + rtP . Ir_21 * t17 * t130 * 0.5 ) + rtP . Ir_33 * t17 * t118 * 0.25
) + rtP . Ir_31 * t17 * t21 * 0.25 ) - rtP . Ir_31 * t17 * t130 * 0.25 ) +
rtP . Ir_31 * t17 * t77 * 0.75 ) + rtP . Ir_31 * t17 * t140 * 0.375 ) - rtP .
Ir_31 * t17 * t142 * 0.375 ) - rtP . Ir_22 * t4 * t174 * 0.125 ) + rtP .
Ir_22 * t4 * t175 * 0.125 ) - rtP . Ir_11 * t17 * t174 * 0.125 ) + rtP .
Ir_11 * t4 * t141 * 0.0625 ) ) + rtP . Ir_11 * t4 * t127 * 0.03125 ) - rtP .
Ir_11 * t17 * t137 * 0.375 ) - rtP . Ir_11 * t4 * t131 * 0.03125 ) - rtP .
Ir_11 * t17 * t177 * 0.1875 ) + rtP . Ir_11 * t17 * t178 * 0.1875 ) + rtP .
Ir_33 * t4 * t174 * 0.125 ) - rtP . Ir_32 * t4 * t137 * 0.125 ) - rtP . Ir_33
* t4 * t175 * 0.125 ) - rtP . Ir_32 * t4 * t177 * 0.125 ) - rtP . Ir_32 * t4
* t178 * 0.125 ) + rtP . Ir_32 * t17 * t174 * 0.5 ) + rtP . Ir_32 * t17 *
t175 * 0.5 ) + rtP . Ir_33 * t17 * t174 * 0.125 ) - rtP . Ir_33 * t4 * t141 *
0.0625 ) - rtP . Ir_33 * t17 * t175 * 0.125 ) - rtP . Ir_33 * t4 * t127 *
0.03125 ) + rtP . Ir_33 * t17 * t137 * 0.375 ) + rtP . Ir_33 * t4 * t131 *
0.03125 ) + rtP . Ir_33 * t17 * t177 * 0.1875 ) - rtP . Ir_33 * t17 * t178 *
0.1875 ) + rtP . Ir_31 * t4 * t68 * 0.125 ) - rtP . Ir_31 * t4 * t220 * 0.125
) - rtP . Ir_31 * t4 * t221 * 0.0625 ) + rtP . Ir_31 * t4 * t222 * 0.0625 ) -
muDoubleScalarCos ( ( rtB . hkbmt1bwgv [ 5 ] * - 3.0 + t19 ) + t20 ) * ( rtP
. Ii_21 * t5 ) * 0.125 ) + muDoubleScalarCos ( ( rtB . hkbmt1bwgv [ 5 ] * -
2.0 + t19 ) + t20 ) * ( rtP . Ii_31 * t5 ) * 0.125 ) - muDoubleScalarCos ( (
rtB . hkbmt1bwgv [ 5 ] * - 4.0 + t19 ) + t20 ) * ( rtP . Ii_31 * t5 ) *
0.0625 ) - muDoubleScalarCos ( ( rtB . hkbmt1bwgv [ 7 ] * - 3.0 + t19 ) + t24
) * ( rtP . Io_21 * t8 ) * 0.125 ) + muDoubleScalarCos ( ( rtB . hkbmt1bwgv [
7 ] * - 2.0 + t19 ) + t24 ) * ( rtP . Io_31 * t8 ) * 0.125 ) -
muDoubleScalarCos ( ( rtB . hkbmt1bwgv [ 7 ] * - 4.0 + t19 ) + t24 ) * ( rtP
. Io_31 * t8 ) * 0.0625 ) + rtP . Il_21 * t15 * muDoubleScalarCos ( t55 ) *
0.5 ) + rtP . Il_21 * t15 * muDoubleScalarCos ( t43 ) * 0.5 ) + rtP . Ir_21 *
t17 * muDoubleScalarCos ( t61 ) * 0.5 ) + rtP . Ir_21 * t17 *
muDoubleScalarCos ( t173 ) * 0.5 ) - rtP . Ii_21 * ehrq52oenb [ 5 ] * t73 *
ehrq52oenb [ 2 ] * 0.125 ) - rtP . Ii_21 * ehrq52oenb [ 5 ] * t81 *
ehrq52oenb [ 2 ] * 0.375 ) - rtP . Ii_32 * ehrq52oenb [ 5 ] * t70 *
ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ii_31 * ehrq52oenb [ 5 ] * t76 * ehrq52oenb
[ 2 ] * 0.25 ) - rtP . Ii_31 * ehrq52oenb [ 5 ] * t78 * ehrq52oenb [ 2 ] *
0.25 ) - rtP . Ii_11 * ehrq52oenb [ 5 ] * t99 * ehrq52oenb [ 2 ] * 0.125 ) -
rtP . Ii_22 * ehrq52oenb [ 5 ] * t95 * ehrq52oenb [ 2 ] * 0.25 ) - rtP .
Ii_33 * ehrq52oenb [ 5 ] * t96 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ii_33 *
ehrq52oenb [ 5 ] * t98 * ehrq52oenb [ 2 ] * 0.125 ) - rtP . Ii_32 *
ehrq52oenb [ 5 ] * t113 * ehrq52oenb [ 2 ] * 0.375 ) - rtP . Ii_32 *
ehrq52oenb [ 5 ] * t114 * ehrq52oenb [ 2 ] * 0.375 ) - rtP . Ii_21 *
ehrq52oenb [ 5 ] * t144 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ii_11 *
ehrq52oenb [ 5 ] * t32 * ehrq52oenb [ 2 ] * 0.5 ) - rtP . Ii_21 * ehrq52oenb
[ 5 ] * t148 * ehrq52oenb [ 2 ] * 0.75 ) - rtP . Ii_33 * ehrq52oenb [ 5 ] *
t40 * ehrq52oenb [ 2 ] * 0.5 ) - rtP . Ii_11 * ehrq52oenb [ 5 ] * t105 *
ehrq52oenb [ 2 ] * 0.75 ) - rtP . Ii_32 * ehrq52oenb [ 5 ] * t143 *
ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ii_32 * ehrq52oenb [ 5 ] * t145 *
ehrq52oenb [ 2 ] * 0.75 ) - rtP . Ii_32 * ehrq52oenb [ 5 ] * t147 *
ehrq52oenb [ 2 ] * 0.75 ) - rtP . Ii_22 * ehrq52oenb [ 5 ] * t151 *
ehrq52oenb [ 2 ] * 0.5 ) + rtP . Il_21 * rtB . hkbmt1bwgv [ 11 ] * t12 *
ehrq52oenb [ 2 ] * 0.25 ) - rtP . Il_32 * rtB . hkbmt1bwgv [ 11 ] * t16 *
ehrq52oenb [ 2 ] * 0.25 ) - rtP . Il_21 * rtB . hkbmt1bwgv [ 11 ] * t31 *
ehrq52oenb [ 2 ] * 0.125 ) + rtP . Il_21 * rtB . hkbmt1bwgv [ 11 ] * t33 *
ehrq52oenb [ 2 ] * 0.125 ) - rtP . Il_21 * rtB . hkbmt1bwgv [ 11 ] * t9 *
ehrq52oenb [ 2 ] * 0.25 ) - rtP . Il_21 * rtB . hkbmt1bwgv [ 11 ] * t42 *
ehrq52oenb [ 2 ] * 0.75 ) - rtP . Il_11 * rtB . hkbmt1bwgv [ 11 ] * t66 *
ehrq52oenb [ 2 ] * 0.5 ) - rtP . Il_32 * rtB . hkbmt1bwgv [ 11 ] * t52 *
ehrq52oenb [ 2 ] * 0.375 ) + rtP . Il_32 * rtB . hkbmt1bwgv [ 11 ] * t53 *
ehrq52oenb [ 2 ] * 0.375 ) + rtP . Il_32 * rtB . hkbmt1bwgv [ 11 ] * t56 *
ehrq52oenb [ 2 ] * 0.25 ) - rtP . Il_32 * rtB . hkbmt1bwgv [ 11 ] * t57 *
ehrq52oenb [ 2 ] * 0.75 ) + rtP . Il_33 * rtB . hkbmt1bwgv [ 11 ] * t66 *
ehrq52oenb [ 2 ] * 0.5 ) + rtP . Il_21 * rtB . hkbmt1bwgv [ 11 ] * t132 *
ehrq52oenb [ 2 ] * 0.75 ) + rtP . Il_21 * rtB . hkbmt1bwgv [ 11 ] * t134 *
ehrq52oenb [ 2 ] * 0.375 ) - rtP . Il_31 * rtB . hkbmt1bwgv [ 11 ] * t124 *
ehrq52oenb [ 2 ] * 0.25 ) - rtP . Il_21 * rtB . hkbmt1bwgv [ 11 ] * t136 *
ehrq52oenb [ 2 ] * 0.375 ) - rtP . Il_31 * rtB . hkbmt1bwgv [ 11 ] * t13 *
ehrq52oenb [ 2 ] * 0.25 ) + rtP . Il_22 * rtB . hkbmt1bwgv [ 11 ] * t46 *
ehrq52oenb [ 2 ] * 0.25 ) + rtP . Il_22 * rtB . hkbmt1bwgv [ 11 ] * t125 *
ehrq52oenb [ 2 ] * 0.25 ) - rtP . Il_11 * rtB . hkbmt1bwgv [ 11 ] * t182 *
ehrq52oenb [ 2 ] * 0.5 ) - rtP . Il_11 * rtB . hkbmt1bwgv [ 11 ] * t139 *
ehrq52oenb [ 2 ] * 0.125 ) - rtP . Il_11 * rtB . hkbmt1bwgv [ 11 ] * t123 *
ehrq52oenb [ 2 ] * 0.125 ) - rtP . Il_33 * rtB . hkbmt1bwgv [ 11 ] * t46 *
ehrq52oenb [ 2 ] * 0.25 ) + rtP . Il_32 * rtB . hkbmt1bwgv [ 11 ] * t170 *
ehrq52oenb [ 2 ] * 0.75 ) - rtP . Il_33 * rtB . hkbmt1bwgv [ 11 ] * t125 *
ehrq52oenb [ 2 ] * 0.25 ) + rtP . Il_32 * rtB . hkbmt1bwgv [ 11 ] * t133 *
ehrq52oenb [ 2 ] * 0.375 ) - rtP . Il_32 * rtB . hkbmt1bwgv [ 11 ] * t172 *
ehrq52oenb [ 2 ] * 0.375 ) + rtP . Il_33 * rtB . hkbmt1bwgv [ 11 ] * t182 *
ehrq52oenb [ 2 ] * 0.5 ) + rtP . Il_33 * rtB . hkbmt1bwgv [ 11 ] * t139 *
ehrq52oenb [ 2 ] * 0.125 ) + rtP . Il_33 * rtB . hkbmt1bwgv [ 11 ] * t123 *
ehrq52oenb [ 2 ] * 0.125 ) - rtP . Il_11 * rtB . hkbmt1bwgv [ 11 ] * t214 *
ehrq52oenb [ 2 ] * 0.75 ) + rtP . Il_31 * rtB . hkbmt1bwgv [ 11 ] * t65 *
ehrq52oenb [ 2 ] ) - rtP . Il_22 * rtB . hkbmt1bwgv [ 11 ] * t213 *
ehrq52oenb [ 2 ] * 0.5 ) + rtP . Il_33 * rtB . hkbmt1bwgv [ 11 ] * t213 *
ehrq52oenb [ 2 ] * 0.5 ) + rtP . Il_33 * rtB . hkbmt1bwgv [ 11 ] * t214 *
ehrq52oenb [ 2 ] * 0.75 ) + rtP . Il_31 * rtB . hkbmt1bwgv [ 11 ] * t217 *
ehrq52oenb [ 2 ] ) + rtP . Il_31 * rtB . hkbmt1bwgv [ 11 ] * t100 *
ehrq52oenb [ 2 ] * 0.25 ) + rtP . Il_31 * rtB . hkbmt1bwgv [ 11 ] * t219 *
ehrq52oenb [ 2 ] * 0.25 ) - rtP . Io_32 * rtB . hkbmt1bwgv [ 10 ] * t71 *
ehrq52oenb [ 2 ] * 0.25 ) - rtP . Io_21 * rtB . hkbmt1bwgv [ 10 ] * t83 *
ehrq52oenb [ 2 ] * 0.125 ) - rtP . Io_21 * rtB . hkbmt1bwgv [ 10 ] * t91 *
ehrq52oenb [ 2 ] * 0.375 ) - rtP . Io_31 * rtB . hkbmt1bwgv [ 10 ] * t86 *
ehrq52oenb [ 2 ] * 0.25 ) - rtP . Io_11 * rtB . hkbmt1bwgv [ 10 ] * t107 *
ehrq52oenb [ 2 ] * 0.125 ) - rtP . Io_31 * rtB . hkbmt1bwgv [ 10 ] * t88 *
ehrq52oenb [ 2 ] * 0.25 ) - rtP . Io_22 * rtB . hkbmt1bwgv [ 10 ] * t103 *
ehrq52oenb [ 2 ] * 0.25 ) - rtP . Io_33 * rtB . hkbmt1bwgv [ 10 ] * t104 *
ehrq52oenb [ 2 ] * 0.25 ) - rtP . Io_33 * rtB . hkbmt1bwgv [ 10 ] * t106 *
ehrq52oenb [ 2 ] * 0.125 ) - rtP . Io_32 * rtB . hkbmt1bwgv [ 10 ] * t116 *
ehrq52oenb [ 2 ] * 0.375 ) - rtP . Io_32 * rtB . hkbmt1bwgv [ 10 ] * t117 *
ehrq52oenb [ 2 ] * 0.375 ) - rtP . Io_21 * rtB . hkbmt1bwgv [ 10 ] * t45 *
ehrq52oenb [ 2 ] * 0.25 ) - rtP . Io_11 * rtB . hkbmt1bwgv [ 10 ] * t36 *
ehrq52oenb [ 2 ] * 0.5 ) - rtP . Io_21 * rtB . hkbmt1bwgv [ 10 ] * t30 *
ehrq52oenb [ 2 ] * 0.75 ) - rtP . Io_33 * rtB . hkbmt1bwgv [ 10 ] * t34 *
ehrq52oenb [ 2 ] * 0.5 ) - rtP . Io_11 * rtB . hkbmt1bwgv [ 10 ] * t156 *
ehrq52oenb [ 2 ] * 0.75 ) - rtP . Io_32 * rtB . hkbmt1bwgv [ 10 ] * t129 *
ehrq52oenb [ 2 ] * 0.25 ) - rtP . Io_22 * rtB . hkbmt1bwgv [ 10 ] * t159 *
ehrq52oenb [ 2 ] * 0.5 ) - rtP . Io_32 * rtB . hkbmt1bwgv [ 10 ] * t135 *
ehrq52oenb [ 2 ] * 0.75 ) - rtP . Io_32 * rtB . hkbmt1bwgv [ 10 ] * t149 *
ehrq52oenb [ 2 ] * 0.75 ) + rtP . Ir_21 * ehrq52oenb [ 7 ] * t14 * ehrq52oenb
[ 2 ] * 0.25 ) - rtP . Ir_32 * ehrq52oenb [ 7 ] * t18 * ehrq52oenb [ 2 ] *
0.25 ) - rtP . Ir_21 * ehrq52oenb [ 7 ] * t35 * ehrq52oenb [ 2 ] * 0.125 ) +
rtP . Ir_21 * ehrq52oenb [ 7 ] * t37 * ehrq52oenb [ 2 ] * 0.125 ) - rtP .
Ir_21 * ehrq52oenb [ 7 ] * t11 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ir_21 *
ehrq52oenb [ 7 ] * t47 * ehrq52oenb [ 2 ] * 0.75 ) - rtP . Ir_11 * ehrq52oenb
[ 7 ] * t69 * ehrq52oenb [ 2 ] * 0.5 ) - rtP . Ir_32 * ehrq52oenb [ 7 ] * t58
* ehrq52oenb [ 2 ] * 0.375 ) + rtP . Ir_32 * ehrq52oenb [ 7 ] * t59 *
ehrq52oenb [ 2 ] * 0.375 ) + rtP . Ir_32 * ehrq52oenb [ 7 ] * t62 *
ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ir_32 * ehrq52oenb [ 7 ] * t63 * ehrq52oenb
[ 2 ] * 0.75 ) + rtP . Ir_33 * ehrq52oenb [ 7 ] * t69 * ehrq52oenb [ 2 ] *
0.5 ) ) - rtP . Ir_31 * ehrq52oenb [ 7 ] * t21 * ehrq52oenb [ 2 ] * 0.25 ) +
rtP . Ir_21 * ehrq52oenb [ 7 ] * t140 * ehrq52oenb [ 2 ] * 0.375 ) - rtP .
Ir_31 * ehrq52oenb [ 7 ] * t130 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ir_21 *
ehrq52oenb [ 7 ] * t142 * ehrq52oenb [ 2 ] * 0.375 ) + rtP . Ir_22 *
ehrq52oenb [ 7 ] * t174 * ehrq52oenb [ 2 ] * 0.25 ) + rtP . Ir_22 *
ehrq52oenb [ 7 ] * t175 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ir_11 *
ehrq52oenb [ 7 ] * t141 * ehrq52oenb [ 2 ] * 0.5 ) - rtP . Ir_11 * ehrq52oenb
[ 7 ] * t127 * ehrq52oenb [ 2 ] * 0.125 ) - rtP . Ir_11 * ehrq52oenb [ 7 ] *
t131 * ehrq52oenb [ 2 ] * 0.125 ) - rtP . Ir_33 * ehrq52oenb [ 7 ] * t174 *
ehrq52oenb [ 2 ] * 0.25 ) + rtP . Ir_32 * ehrq52oenb [ 7 ] * t137 *
ehrq52oenb [ 2 ] * 0.75 ) - rtP . Ir_33 * ehrq52oenb [ 7 ] * t175 *
ehrq52oenb [ 2 ] * 0.25 ) + rtP . Ir_32 * ehrq52oenb [ 7 ] * t177 *
ehrq52oenb [ 2 ] * 0.375 ) - rtP . Ir_32 * ehrq52oenb [ 7 ] * t178 *
ehrq52oenb [ 2 ] * 0.375 ) + rtP . Ir_33 * ehrq52oenb [ 7 ] * t141 *
ehrq52oenb [ 2 ] * 0.5 ) + rtP . Ir_33 * ehrq52oenb [ 7 ] * t127 * ehrq52oenb
[ 2 ] * 0.125 ) + rtP . Ir_33 * ehrq52oenb [ 7 ] * t131 * ehrq52oenb [ 2 ] *
0.125 ) - rtP . Ir_11 * ehrq52oenb [ 7 ] * t216 * ehrq52oenb [ 2 ] * 0.75 ) +
rtP . Ir_31 * ehrq52oenb [ 7 ] * t68 * ehrq52oenb [ 2 ] ) - rtP . Ir_22 *
ehrq52oenb [ 7 ] * t215 * ehrq52oenb [ 2 ] * 0.5 ) + rtP . Ir_33 * ehrq52oenb
[ 7 ] * t215 * ehrq52oenb [ 2 ] * 0.5 ) + rtP . Ir_33 * ehrq52oenb [ 7 ] *
t216 * ehrq52oenb [ 2 ] * 0.75 ) + rtP . Ir_31 * ehrq52oenb [ 7 ] * t220 *
ehrq52oenb [ 2 ] ) + rtP . Ir_31 * ehrq52oenb [ 7 ] * t221 * ehrq52oenb [ 2 ]
* 0.25 ) + rtP . Ir_31 * ehrq52oenb [ 7 ] * t222 * ehrq52oenb [ 2 ] * 0.25 )
+ rtP . Il_31 * rtB . hkbmt1bwgv [ 11 ] * ehrq52oenb [ 2 ] *
muDoubleScalarCos ( t54 ) * 0.5 ) + rtP . Il_31 * rtB . hkbmt1bwgv [ 11 ] *
ehrq52oenb [ 2 ] * muDoubleScalarCos ( t64 ) * 1.5 ) + rtP . Ir_31 *
ehrq52oenb [ 7 ] * ehrq52oenb [ 2 ] * muDoubleScalarCos ( t60 ) * 0.5 ) + rtP
. Ir_31 * ehrq52oenb [ 7 ] * ehrq52oenb [ 2 ] * muDoubleScalarCos ( t67 ) *
1.5 ) - rtP . Ii_21 * ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t73 * 0.125 ) -
rtP . Ii_21 * ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t81 * 0.375 ) - rtP .
Ii_32 * ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t70 * 0.25 ) - rtP . Ii_31 *
ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t76 * 0.25 ) - rtP . Ii_31 * ehrq52oenb
[ 3 ] * ehrq52oenb [ 5 ] * t78 * 0.25 ) - rtP . Ii_11 * ehrq52oenb [ 3 ] *
ehrq52oenb [ 5 ] * t99 * 0.125 ) - rtP . Ii_22 * ehrq52oenb [ 3 ] *
ehrq52oenb [ 5 ] * t95 * 0.25 ) - rtP . Ii_33 * ehrq52oenb [ 3 ] * ehrq52oenb
[ 5 ] * t96 * 0.25 ) - rtP . Ii_33 * ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] *
t98 * 0.125 ) - rtP . Ii_32 * ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t113 *
0.375 ) - rtP . Ii_32 * ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t114 * 0.375 )
- rtP . Ii_21 * ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t144 * 0.25 ) - rtP .
Ii_11 * ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t32 * 0.5 ) - rtP . Ii_21 *
ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t148 * 0.75 ) - rtP . Ii_33 *
ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t40 * 0.5 ) - rtP . Ii_11 * ehrq52oenb
[ 3 ] * ehrq52oenb [ 5 ] * t105 * 0.75 ) - rtP . Ii_32 * ehrq52oenb [ 3 ] *
ehrq52oenb [ 5 ] * t143 * 0.25 ) - rtP . Ii_32 * ehrq52oenb [ 3 ] *
ehrq52oenb [ 5 ] * t145 * 0.75 ) - rtP . Ii_32 * ehrq52oenb [ 3 ] *
ehrq52oenb [ 5 ] * t147 * 0.75 ) - rtP . Ii_22 * ehrq52oenb [ 3 ] *
ehrq52oenb [ 5 ] * t151 * 0.5 ) - rtP . Io_32 * rtB . hkbmt1bwgv [ 9 ] * rtB
. hkbmt1bwgv [ 10 ] * t71 * 0.25 ) - rtP . Io_21 * rtB . hkbmt1bwgv [ 9 ] *
rtB . hkbmt1bwgv [ 10 ] * t83 * 0.125 ) - rtP . Io_21 * rtB . hkbmt1bwgv [ 9
] * rtB . hkbmt1bwgv [ 10 ] * t91 * 0.375 ) - rtP . Io_31 * rtB . hkbmt1bwgv
[ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t86 * 0.25 ) - rtP . Io_11 * rtB .
hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t107 * 0.125 ) - rtP . Io_31 *
rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t88 * 0.25 ) - rtP . Io_22
* rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t103 * 0.25 ) - rtP .
Io_33 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t104 * 0.25 ) -
rtP . Io_33 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t106 * 0.125
) - rtP . Io_32 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t116 *
0.375 ) - rtP . Io_32 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] *
t117 * 0.375 ) - rtP . Io_21 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10
] * t45 * 0.25 ) - rtP . Io_11 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [
10 ] * t36 * 0.5 ) - rtP . Io_21 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv
[ 10 ] * t30 * 0.75 ) - rtP . Io_33 * rtB . hkbmt1bwgv [ 9 ] * rtB .
hkbmt1bwgv [ 10 ] * t34 * 0.5 ) - rtP . Io_11 * rtB . hkbmt1bwgv [ 9 ] * rtB
. hkbmt1bwgv [ 10 ] * t156 * 0.75 ) - rtP . Io_32 * rtB . hkbmt1bwgv [ 9 ] *
rtB . hkbmt1bwgv [ 10 ] * t129 * 0.25 ) - rtP . Io_22 * rtB . hkbmt1bwgv [ 9
] * rtB . hkbmt1bwgv [ 10 ] * t159 * 0.5 ) - rtP . Io_32 * rtB . hkbmt1bwgv [
9 ] * rtB . hkbmt1bwgv [ 10 ] * t135 * 0.75 ) - rtP . Io_32 * rtB .
hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t149 * 0.75 ) - rtP . Ii_33 *
ehrq52oenb [ 3 ] * t7 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ii_21 * ehrq52oenb
[ 3 ] * t81 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ii_32 * ehrq52oenb [ 3 ] *
t70 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ii_31 * ehrq52oenb [ 3 ] * t76 *
ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ii_11 * ehrq52oenb [ 3 ] * t98 * ehrq52oenb
[ 2 ] * 0.0625 ) - rtP . Ii_11 * ehrq52oenb [ 3 ] * t99 * ehrq52oenb [ 2 ] *
0.0625 ) - rtP . Ii_33 * ehrq52oenb [ 3 ] * t95 * ehrq52oenb [ 2 ] * 0.25 ) -
rtP . Ii_21 * ehrq52oenb [ 3 ] * t108 * ehrq52oenb [ 2 ] * 0.25 ) - rtP .
Ii_33 * ehrq52oenb [ 3 ] * t96 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ii_22 *
ehrq52oenb [ 3 ] * t120 * ehrq52oenb [ 2 ] * 0.5 ) - rtP . Ii_32 * ehrq52oenb
[ 3 ] * t112 * ehrq52oenb [ 2 ] * 0.75 ) - rtP . Ii_32 * ehrq52oenb [ 3 ] *
t114 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ii_21 * ehrq52oenb [ 3 ] * t146 *
ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ii_11 * ehrq52oenb [ 3 ] * t40 * ehrq52oenb
[ 2 ] * 0.125 ) - rtP . Ii_11 * ehrq52oenb [ 3 ] * t32 * ehrq52oenb [ 2 ] *
0.125 ) - rtP . Ii_21 * ehrq52oenb [ 3 ] * t148 * ehrq52oenb [ 2 ] * 0.25 ) -
rtP . Ii_31 * ehrq52oenb [ 3 ] * t38 * ehrq52oenb [ 2 ] * 0.25 ) - rtP .
Ii_32 * ehrq52oenb [ 3 ] * t147 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ii_31 *
ehrq52oenb [ 3 ] * t153 * ehrq52oenb [ 2 ] * 0.125 ) - rtP . Io_33 * rtB .
hkbmt1bwgv [ 9 ] * t10 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Io_32 * rtB .
hkbmt1bwgv [ 9 ] * t71 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Io_21 * rtB .
hkbmt1bwgv [ 9 ] * t91 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Io_11 * rtB .
hkbmt1bwgv [ 9 ] * t106 * ehrq52oenb [ 2 ] * 0.0625 ) - rtP . Io_31 * rtB .
hkbmt1bwgv [ 9 ] * t86 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Io_11 * rtB .
hkbmt1bwgv [ 9 ] * t107 * ehrq52oenb [ 2 ] * 0.0625 ) - rtP . Io_21 * rtB .
hkbmt1bwgv [ 9 ] * t110 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Io_33 * rtB .
hkbmt1bwgv [ 9 ] * t103 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Io_33 * rtB .
hkbmt1bwgv [ 9 ] * t104 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Io_22 * rtB .
hkbmt1bwgv [ 9 ] * t122 * ehrq52oenb [ 2 ] * 0.5 ) - rtP . Io_32 * rtB .
hkbmt1bwgv [ 9 ] * t115 * ehrq52oenb [ 2 ] * 0.75 ) - rtP . Io_32 * rtB .
hkbmt1bwgv [ 9 ] * t117 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Io_11 * rtB .
hkbmt1bwgv [ 9 ] * t34 * ehrq52oenb [ 2 ] * 0.125 ) - rtP . Io_11 * rtB .
hkbmt1bwgv [ 9 ] * t36 * ehrq52oenb [ 2 ] * 0.125 ) - rtP . Io_21 * rtB .
hkbmt1bwgv [ 9 ] * t25 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Io_21 * rtB .
hkbmt1bwgv [ 9 ] * t30 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Io_31 * rtB .
hkbmt1bwgv [ 9 ] * t41 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Io_32 * rtB .
hkbmt1bwgv [ 9 ] * t149 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Io_31 * rtB .
hkbmt1bwgv [ 9 ] * t97 * ehrq52oenb [ 2 ] * 0.125 ; owi2j0naiy [ 3 ] = ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( t223 + t224 ) + t225 ) + t226 ) + t227 ) + t228 ) + t160 ) + t230 )
+ t231 ) + t232 ) + t233 ) + t234 ) + t74 ) + t92 ) + t84 ) + t186 ) + t185 )
+ t181 ) + t180 ) + t179 ) + t48 ) + t50 ) + t72 ) + t75 ) + t80 ) + t82 ) +
t85 ) + t87 ) + t90 ) + t94 ) + t93 ) + t101 ) + t102 ) + t256 ) + t257 ) +
t258 ) + t259 ) + t260 ) + t261 ) + t262 ) + t263 ) + t264 ) + t265 ) + t266
) + t267 ) + t268 ) + t269 ) + t271 ) + t273 ) + t274 ) + t275 ) + t276 ) +
t277 ) + t278 ) + t279 ) + t280 ) + t281 ) + t282 ) + t283 ) + t284 ) + t285
) + t286 ) + t194 ) + t290 ) + t291 ) + t292 ) + t293 ) + t294 ) + t295 ) +
t296 ) + t297 ) + t298 ) + t299 ) + t300 ) + t301 ) + t302 ) + t303 ) + t304
) + t22 ) + t195 ) + t307 ) + t308 ) + t309 ) + t310 ) + t311 ) + t312 ) +
t313 ) + t314 ) + t315 ) + t316 ) + t317 ) + t318 ) + t319 ) + t320 ) + t109
) + t322 ) + t323 ) + t324 ) + t325 ) + t326 ) + t327 ) + t328 ) + t329 ) +
t330 ) + t331 ) + t332 ) + t333 ) + t334 ) + t335 ) + t336 ) + t337 ) + t338
) + t339 ) + t340 ) + t341 ) + t342 ) + t343 ) + t344 ) + t345 ) + t346 ) +
t347 ) + t348 ) + t349 ) + t350 ) + t351 ) + t352 ) + t353 ) - rtP . Ii_33 *
t4 * t7 * 0.125 ) - rtP . Ii_33 * t5 * t7 * 0.125 ) - rtP . Ii_22 * t23 * t28
* 0.25 ) - rtP . Ii_31 * t23 * t49 * 0.25 ) - rtP . Ii_21 * t4 * t81 * 0.125
) - rtP . Ii_32 * t4 * t70 * 0.125 ) - rtP . Ii_21 * t5 * t81 * 0.125 ) - rtP
. Ii_32 * t5 * t70 * 0.125 ) - rtP . Ii_31 * t4 * t76 * 0.125 ) - rtP . Ii_31
* t5 * t76 * 0.125 ) - rtP . Ii_11 * t4 * t98 * 0.03125 ) - rtP . Ii_11 * t4
* t99 * 0.03125 ) - rtP . Ii_11 * t5 * t98 * 0.03125 ) + rtP . Ii_31 * t5 *
t78 * 0.125 ) - rtP . Ii_11 * t5 * t99 * 0.03125 ) - rtP . Ii_33 * t23 * t70
* 0.125 ) - rtP . Ii_31 * t23 * t73 * 0.125 ) - rtP . Ii_31 * t23 * t76 *
0.25 ) - rtP . Ii_33 * t4 * t95 * 0.125 ) - rtP . Ii_21 * t4 * t108 * 0.125 )
- rtP . Ii_33 * t4 * t96 * 0.125 ) - rtP . Ii_33 * t5 * t95 * 0.125 ) - rtP .
Ii_21 * t5 * t108 * 0.125 ) - rtP . Ii_33 * t5 * t96 * 0.125 ) - rtP . Ii_31
* t23 * t81 * 0.375 ) - rtP . Ii_22 * t4 * t120 * 0.25 ) - rtP . Ii_22 * t5 *
t120 * 0.25 ) - rtP . Ii_32 * t4 * t112 * 0.375 ) - rtP . Ii_32 * t5 * t112 *
0.375 ) - rtP . Ii_32 * t4 * t114 * 0.125 ) - rtP . Ii_32 * t23 * t95 * 0.5 )
- rtP . Ii_32 * t5 * t114 * 0.125 ) - rtP . Ii_33 * t23 * t95 * 0.125 ) - rtP
. Ii_33 * t23 * t96 * 0.125 ) - rtP . Ii_22 * t23 * t112 * 0.25 ) - rtP .
Ii_22 * t23 * t120 * 0.5 ) - rtP . Ii_32 * t23 * t112 * 0.5 ) - rtP . Ii_33 *
t23 * t113 * 0.1875 ) - rtP . Ii_33 * t23 * t114 * 0.1875 ) - rtP . Ii_21 *
t4 * t146 * 0.125 ) - rtP . Ii_11 * t4 * t40 * 0.0625 ) - rtP . Ii_21 * t5 *
t146 * 0.125 ) - rtP . Ii_11 * t4 * t32 * 0.0625 ) - rtP . Ii_11 * t5 * t40 *
0.0625 ) - rtP . Ii_21 * t4 * t148 * 0.125 ) - rtP . Ii_11 * t5 * t32 *
0.0625 ) - rtP . Ii_21 * t5 * t148 * 0.125 ) - rtP . Ii_31 * t4 * t38 * 0.125
) - rtP . Ii_31 * t5 * t38 * 0.125 ) - rtP . Ii_31 * t23 * t148 * 0.75 ) -
rtP . Ii_32 * t4 * t147 * 0.125 ) - rtP . Ii_32 * t5 * t147 * 0.125 ) - rtP .
Ii_31 * t4 * t153 * 0.0625 ) - rtP . Ii_31 * t5 * t153 * 0.0625 ) - rtP .
Ii_33 * t23 * t143 * 0.125 ) - rtP . Ii_33 * t23 * t145 * 0.375 ) - rtP .
Ii_33 * t23 * t147 * 0.375 ) - rtP . Ii_32 * t23 * t287 * 0.5 ) - rtP . Ii_21
* ehrq52oenb [ 5 ] * t73 * ehrq52oenb [ 2 ] * 0.125 ) - rtP . Ii_21 *
ehrq52oenb [ 5 ] * t81 * ehrq52oenb [ 2 ] * 0.375 ) - rtP . Ii_32 *
ehrq52oenb [ 5 ] * t70 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ii_31 * ehrq52oenb
[ 5 ] * t76 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ii_31 * ehrq52oenb [ 5 ] *
t78 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ii_11 * ehrq52oenb [ 5 ] * t99 *
ehrq52oenb [ 2 ] * 0.125 ) - rtP . Ii_22 * ehrq52oenb [ 5 ] * t95 *
ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ii_33 * ehrq52oenb [ 5 ] * t96 * ehrq52oenb
[ 2 ] * 0.25 ) - rtP . Ii_33 * ehrq52oenb [ 5 ] * t98 * ehrq52oenb [ 2 ] *
0.125 ) - rtP . Ii_32 * ehrq52oenb [ 5 ] * t113 * ehrq52oenb [ 2 ] * 0.375 )
- rtP . Ii_32 * ehrq52oenb [ 5 ] * t114 * ehrq52oenb [ 2 ] * 0.375 ) - rtP .
Ii_21 * ehrq52oenb [ 5 ] * t144 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ii_11 *
ehrq52oenb [ 5 ] * t32 * ehrq52oenb [ 2 ] * 0.5 ) - rtP . Ii_21 * ehrq52oenb
[ 5 ] * t148 * ehrq52oenb [ 2 ] * 0.75 ) - rtP . Ii_33 * ehrq52oenb [ 5 ] *
t40 * ehrq52oenb [ 2 ] * 0.5 ) - rtP . Ii_11 * ehrq52oenb [ 5 ] * t105 *
ehrq52oenb [ 2 ] * 0.75 ) - rtP . Ii_32 * ehrq52oenb [ 5 ] * t143 *
ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ii_32 * ehrq52oenb [ 5 ] * t145 *
ehrq52oenb [ 2 ] * 0.75 ) - rtP . Ii_32 * ehrq52oenb [ 5 ] * t147 *
ehrq52oenb [ 2 ] * 0.75 ) - rtP . Ii_22 * ehrq52oenb [ 5 ] * t151 *
ehrq52oenb [ 2 ] * 0.5 ) - rtP . Ii_21 * ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ]
* t73 * 0.125 ) - rtP . Ii_21 * ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t81 *
0.375 ) - rtP . Ii_32 * ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t70 * 0.25 ) -
rtP . Ii_31 * ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t76 * 0.25 ) - rtP .
Ii_31 * ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t78 * 0.25 ) - rtP . Ii_11 *
ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t99 * 0.125 ) - rtP . Ii_22 *
ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t95 * 0.25 ) - rtP . Ii_33 * ehrq52oenb
[ 3 ] * ehrq52oenb [ 5 ] * t96 * 0.25 ) - rtP . Ii_33 * ehrq52oenb [ 3 ] *
ehrq52oenb [ 5 ] * t98 * 0.125 ) - rtP . Ii_32 * ehrq52oenb [ 3 ] *
ehrq52oenb [ 5 ] * t113 * 0.375 ) - rtP . Ii_32 * ehrq52oenb [ 3 ] *
ehrq52oenb [ 5 ] * t114 * 0.375 ) - rtP . Ii_21 * ehrq52oenb [ 3 ] *
ehrq52oenb [ 5 ] * t144 * 0.25 ) - rtP . Ii_11 * ehrq52oenb [ 3 ] *
ehrq52oenb [ 5 ] * t32 * 0.5 ) - rtP . Ii_21 * ehrq52oenb [ 3 ] * ehrq52oenb
[ 5 ] * t148 * 0.75 ) - rtP . Ii_33 * ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] *
t40 * 0.5 ) - rtP . Ii_11 * ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t105 * 0.75
) - rtP . Ii_32 * ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t143 * 0.25 ) - rtP .
Ii_32 * ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t145 * 0.75 ) - rtP . Ii_32 *
ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t147 * 0.75 ) - rtP . Ii_22 *
ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t151 * 0.5 ) - rtP . Ii_33 * ehrq52oenb
[ 3 ] * t7 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ii_21 * ehrq52oenb [ 3 ] * t81
* ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ii_32 * ehrq52oenb [ 3 ] * t70 *
ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ii_31 * ehrq52oenb [ 3 ] * t76 * ehrq52oenb
[ 2 ] * 0.25 ) - rtP . Ii_11 * ehrq52oenb [ 3 ] * t98 * ehrq52oenb [ 2 ] *
0.0625 ) - rtP . Ii_11 * ehrq52oenb [ 3 ] * t99 * ehrq52oenb [ 2 ] * 0.0625 )
- rtP . Ii_33 * ehrq52oenb [ 3 ] * t95 * ehrq52oenb [ 2 ] * 0.25 ) - rtP .
Ii_21 * ehrq52oenb [ 3 ] * t108 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ii_33 *
ehrq52oenb [ 3 ] * t96 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ii_22 * ehrq52oenb
[ 3 ] * t120 * ehrq52oenb [ 2 ] * 0.5 ) - rtP . Ii_32 * ehrq52oenb [ 3 ] *
t112 * ehrq52oenb [ 2 ] * 0.75 ) - rtP . Ii_32 * ehrq52oenb [ 3 ] * t114 *
ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ii_21 * ehrq52oenb [ 3 ] * t146 *
ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ii_11 * ehrq52oenb [ 3 ] * t40 * ehrq52oenb
[ 2 ] * 0.125 ) - rtP . Ii_11 * ehrq52oenb [ 3 ] * t32 * ehrq52oenb [ 2 ] *
0.125 ) - rtP . Ii_21 * ehrq52oenb [ 3 ] * t148 * ehrq52oenb [ 2 ] * 0.25 ) -
rtP . Ii_31 * ehrq52oenb [ 3 ] * t38 * ehrq52oenb [ 2 ] * 0.25 ) - rtP .
Ii_32 * ehrq52oenb [ 3 ] * t147 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ii_31 *
ehrq52oenb [ 3 ] * t153 * ehrq52oenb [ 2 ] * 0.125 ; owi2j0naiy [ 4 ] = ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( t354 + t355 ) + t356 ) + t357 ) + t358 ) + t359 ) + t360 ) + t361 )
+ t362 ) + t363 ) + t364 ) + t365 ) + t366 ) + t164 ) + t368 ) + t369 ) +
t370 ) + t371 ) + t372 ) + t373 ) + t374 ) + t375 ) + t376 ) + t377 ) + t378
) + t379 ) + t380 ) + t381 ) + t382 ) + t383 ) + t384 ) + t385 ) + t386 ) +
t387 ) + t388 ) + t389 ) + t390 ) + t391 ) + t392 ) + t393 ) + t394 ) + t395
) + t396 ) + t397 ) + t398 ) + t399 ) + t400 ) + t402 ) + t404 ) + t405 ) +
t406 ) + t407 ) + t408 ) + t409 ) + t410 ) + t411 ) + t412 ) + t413 ) + t414
) + t415 ) + t416 ) + t417 ) + t200 ) + t421 ) + t422 ) + t423 ) + t424 ) +
t425 ) + t426 ) + t427 ) + t428 ) + t429 ) + t430 ) + t431 ) + t432 ) + t433
) + t434 ) + t435 ) + t436 ) + t437 ) + t438 ) + t439 ) + t440 ) + t441 ) +
t442 ) + t443 ) + t444 ) + t445 ) + t446 ) + t447 ) + t448 ) + t449 ) + t450
) + t451 ) + t111 ) + t453 ) + t454 ) + t455 ) + t456 ) + t26 ) + t458 ) +
t459 ) + t460 ) + t461 ) + t462 ) + t463 ) + t464 ) + t465 ) + t466 ) + t467
) + t468 ) + t469 ) + t470 ) + t471 ) + t472 ) + t473 ) + t474 ) + t475 ) +
t476 ) + t477 ) + t478 ) + t479 ) + t166 ) + t481 ) + t482 ) + t483 ) + t484
) - rtP . Io_33 * t4 * t10 * 0.125 ) - rtP . Io_33 * t8 * t10 * 0.125 ) - rtP
. Io_22 * t27 * t29 * 0.25 ) - rtP . Io_32 * t4 * t71 * 0.125 ) - rtP . Io_31
* t27 * t51 * 0.25 ) - rtP . Io_32 * t8 * t71 * 0.125 ) - rtP . Io_21 * t4 *
t91 * 0.125 ) - rtP . Io_21 * t8 * t91 * 0.125 ) - rtP . Io_11 * t4 * t106 *
0.03125 ) - rtP . Io_31 * t4 * t86 * 0.125 ) - rtP . Io_11 * t4 * t107 *
0.03125 ) - rtP . Io_11 * t8 * t106 * 0.03125 ) - rtP . Io_31 * t8 * t86 *
0.125 ) - rtP . Io_11 * t8 * t107 * 0.03125 ) + rtP . Io_31 * t8 * t88 *
0.125 ) - rtP . Io_33 * t27 * t71 * 0.125 ) - rtP . Io_21 * t4 * t110 * 0.125
) - rtP . Io_21 * t8 * t110 * 0.125 ) - rtP . Io_33 * t4 * t103 * 0.125 ) -
rtP . Io_31 * t27 * t83 * 0.125 ) - rtP . Io_33 * t4 * t104 * 0.125 ) - rtP .
Io_31 * t27 * t86 * 0.25 ) - rtP . Io_33 * t8 * t103 * 0.125 ) - rtP . Io_33
* t8 * t104 * 0.125 ) - rtP . Io_22 * t4 * t122 * 0.25 ) - rtP . Io_31 * t27
* t91 * 0.375 ) - rtP . Io_32 * t4 * t115 * 0.375 ) - rtP . Io_22 * t8 * t122
* 0.25 ) - rtP . Io_32 * t4 * t117 * 0.125 ) - rtP . Io_32 * t8 * t115 *
0.375 ) - rtP . Io_32 * t8 * t117 * 0.125 ) - rtP . Io_32 * t27 * t103 * 0.5
) - rtP . Io_33 * t27 * t103 * 0.125 ) - rtP . Io_22 * t27 * t115 * 0.25 ) -
rtP . Io_33 * t27 * t104 * 0.125 ) - rtP . Io_22 * t27 * t122 * 0.5 ) - rtP .
Io_32 * t27 * t115 * 0.5 ) - rtP . Io_11 * t4 * t34 * 0.0625 ) - rtP . Io_33
* t27 * t116 * 0.1875 ) - rtP . Io_11 * t4 * t36 * 0.0625 ) - rtP . Io_21 *
t4 * t25 * 0.125 ) - rtP . Io_33 * t27 * t117 * 0.1875 ) - rtP . Io_21 * t4 *
t30 * 0.125 ) - rtP . Io_11 * t8 * t34 * 0.0625 ) - rtP . Io_11 * t8 * t36 *
0.0625 ) - rtP . Io_21 * t8 * t25 * 0.125 ) - rtP . Io_21 * t8 * t30 * 0.125
) - rtP . Io_31 * t4 * t41 * 0.125 ) - rtP . Io_31 * t8 * t41 * 0.125 ) - rtP
. Io_31 * t27 * t30 * 0.75 ) - rtP . Io_32 * t4 * t149 * 0.125 ) - rtP .
Io_32 * t8 * t149 * 0.125 ) - rtP . Io_31 * t4 * t97 * 0.0625 ) - rtP . Io_31
* t8 * t97 * 0.0625 ) - rtP . Io_33 * t27 * t129 * 0.125 ) - rtP . Io_33 *
t27 * t135 * 0.375 ) - rtP . Io_33 * t27 * t149 * 0.375 ) - rtP . Io_32 * t27
* t199 * 0.5 ) - rtP . Io_32 * rtB . hkbmt1bwgv [ 10 ] * t71 * ehrq52oenb [ 2
] * 0.25 ) - rtP . Io_21 * rtB . hkbmt1bwgv [ 10 ] * t83 * ehrq52oenb [ 2 ] *
0.125 ) - rtP . Io_21 * rtB . hkbmt1bwgv [ 10 ] * t91 * ehrq52oenb [ 2 ] *
0.375 ) - rtP . Io_31 * rtB . hkbmt1bwgv [ 10 ] * t86 * ehrq52oenb [ 2 ] *
0.25 ) - rtP . Io_11 * rtB . hkbmt1bwgv [ 10 ] * t107 * ehrq52oenb [ 2 ] *
0.125 ) - rtP . Io_31 * rtB . hkbmt1bwgv [ 10 ] * t88 * ehrq52oenb [ 2 ] *
0.25 ) - rtP . Io_22 * rtB . hkbmt1bwgv [ 10 ] * t103 * ehrq52oenb [ 2 ] *
0.25 ) - rtP . Io_33 * rtB . hkbmt1bwgv [ 10 ] * t104 * ehrq52oenb [ 2 ] *
0.25 ) - rtP . Io_33 * rtB . hkbmt1bwgv [ 10 ] * t106 * ehrq52oenb [ 2 ] *
0.125 ) - rtP . Io_32 * rtB . hkbmt1bwgv [ 10 ] * t116 * ehrq52oenb [ 2 ] *
0.375 ) - rtP . Io_32 * rtB . hkbmt1bwgv [ 10 ] * t117 * ehrq52oenb [ 2 ] *
0.375 ) - rtP . Io_21 * rtB . hkbmt1bwgv [ 10 ] * t45 * ehrq52oenb [ 2 ] *
0.25 ) - rtP . Io_11 * rtB . hkbmt1bwgv [ 10 ] * t36 * ehrq52oenb [ 2 ] * 0.5
) - rtP . Io_21 * rtB . hkbmt1bwgv [ 10 ] * t30 * ehrq52oenb [ 2 ] * 0.75 ) -
rtP . Io_33 * rtB . hkbmt1bwgv [ 10 ] * t34 * ehrq52oenb [ 2 ] * 0.5 ) - rtP
. Io_11 * rtB . hkbmt1bwgv [ 10 ] * t156 * ehrq52oenb [ 2 ] * 0.75 ) - rtP .
Io_32 * rtB . hkbmt1bwgv [ 10 ] * t129 * ehrq52oenb [ 2 ] * 0.25 ) - rtP .
Io_22 * rtB . hkbmt1bwgv [ 10 ] * t159 * ehrq52oenb [ 2 ] * 0.5 ) - rtP .
Io_32 * rtB . hkbmt1bwgv [ 10 ] * t135 * ehrq52oenb [ 2 ] * 0.75 ) - rtP .
Io_32 * rtB . hkbmt1bwgv [ 10 ] * t149 * ehrq52oenb [ 2 ] * 0.75 ) - rtP .
Io_32 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t71 * 0.25 ) - rtP
. Io_21 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t83 * 0.125 ) -
rtP . Io_21 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t91 * 0.375
) - rtP . Io_31 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t86 *
0.25 ) - rtP . Io_11 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] *
t107 * 0.125 ) - rtP . Io_31 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10
] * t88 * 0.25 ) - rtP . Io_22 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [
10 ] * t103 * 0.25 ) - rtP . Io_33 * rtB . hkbmt1bwgv [ 9 ] * rtB .
hkbmt1bwgv [ 10 ] * t104 * 0.25 ) - rtP . Io_33 * rtB . hkbmt1bwgv [ 9 ] *
rtB . hkbmt1bwgv [ 10 ] * t106 * 0.125 ) - rtP . Io_32 * rtB . hkbmt1bwgv [ 9
] * rtB . hkbmt1bwgv [ 10 ] * t116 * 0.375 ) - rtP . Io_32 * rtB . hkbmt1bwgv
[ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t117 * 0.375 ) - rtP . Io_21 * rtB .
hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t45 * 0.25 ) - rtP . Io_11 * rtB
. hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t36 * 0.5 ) - rtP . Io_21 *
rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t30 * 0.75 ) - rtP . Io_33
* rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t34 * 0.5 ) - rtP .
Io_11 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t156 * 0.75 ) -
rtP . Io_32 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t129 * 0.25
) - rtP . Io_22 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t159 *
0.5 ) - rtP . Io_32 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t135
* 0.75 ) - rtP . Io_32 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] *
t149 * 0.75 ) - rtP . Io_33 * rtB . hkbmt1bwgv [ 9 ] * t10 * ehrq52oenb [ 2 ]
* 0.25 ) - rtP . Io_32 * rtB . hkbmt1bwgv [ 9 ] * t71 * ehrq52oenb [ 2 ] *
0.25 ) - rtP . Io_21 * rtB . hkbmt1bwgv [ 9 ] * t91 * ehrq52oenb [ 2 ] * 0.25
) - rtP . Io_11 * rtB . hkbmt1bwgv [ 9 ] * t106 * ehrq52oenb [ 2 ] * 0.0625 )
- rtP . Io_31 * rtB . hkbmt1bwgv [ 9 ] * t86 * ehrq52oenb [ 2 ] * 0.25 ) -
rtP . Io_11 * rtB . hkbmt1bwgv [ 9 ] * t107 * ehrq52oenb [ 2 ] * 0.0625 ) -
rtP . Io_21 * rtB . hkbmt1bwgv [ 9 ] * t110 * ehrq52oenb [ 2 ] * 0.25 ) - rtP
. Io_33 * rtB . hkbmt1bwgv [ 9 ] * t103 * ehrq52oenb [ 2 ] * 0.25 ) - rtP .
Io_33 * rtB . hkbmt1bwgv [ 9 ] * t104 * ehrq52oenb [ 2 ] * 0.25 ) - rtP .
Io_22 * rtB . hkbmt1bwgv [ 9 ] * t122 * ehrq52oenb [ 2 ] * 0.5 ) - rtP .
Io_32 * rtB . hkbmt1bwgv [ 9 ] * t115 * ehrq52oenb [ 2 ] * 0.75 ) - rtP .
Io_32 * rtB . hkbmt1bwgv [ 9 ] * t117 * ehrq52oenb [ 2 ] * 0.25 ) - rtP .
Io_11 * rtB . hkbmt1bwgv [ 9 ] * t34 * ehrq52oenb [ 2 ] * 0.125 ) - rtP .
Io_11 * rtB . hkbmt1bwgv [ 9 ] * t36 * ehrq52oenb [ 2 ] * 0.125 ) - rtP .
Io_21 * rtB . hkbmt1bwgv [ 9 ] * t25 * ehrq52oenb [ 2 ] * 0.25 ) - rtP .
Io_21 * rtB . hkbmt1bwgv [ 9 ] * t30 * ehrq52oenb [ 2 ] * 0.25 ) - rtP .
Io_31 * rtB . hkbmt1bwgv [ 9 ] * t41 * ehrq52oenb [ 2 ] * 0.25 ) - rtP .
Io_32 * rtB . hkbmt1bwgv [ 9 ] * t149 * ehrq52oenb [ 2 ] * 0.25 ) - rtP .
Io_31 * rtB . hkbmt1bwgv [ 9 ] * t97 * ehrq52oenb [ 2 ] * 0.125 ; owi2j0naiy
[ 5 ] = ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( rtP . Ii_11 * t4 * t105 * 0.375 + rtP . Constant_Value [ 0
] ) + rtP . Ii_11 * t5 * t105 * 0.375 ) + rtP . Ii_22 * t4 * t151 * 0.25 ) +
rtP . Ii_22 * t5 * t151 * 0.25 ) + rtP . Ii_11 * t23 * t151 * 0.25 ) - rtP .
Ii_33 * t4 * t151 * 0.25 ) - rtP . Ii_33 * t4 * t105 * 0.375 ) - rtP . Ii_33
* t5 * t151 * 0.25 ) - rtP . Ii_31 * t4 * t155 * 0.25 ) - rtP . Ii_33 * t5 *
t105 * 0.375 ) - rtP . Ii_31 * t4 * t210 * 0.75 ) - rtP . Ii_31 * t5 * t155 *
0.25 ) - rtP . Ii_31 * t5 * t210 * 0.75 ) - rtP . Ii_33 * t23 * t151 * 0.25 )
- rtP . Ii_31 * t23 * t155 * 0.5 ) + rtP . Ii_32 * t2 * t4 * t485 * 0.5 ) +
rtP . Ii_32 * t2 * t5 * t485 * 0.5 ) + rtP . Ii_32 * t3 * t4 * t486 * 0.5 ) +
rtP . Ii_32 * t3 * t5 * t486 * 0.5 ) - rtP . Ii_32 * t4 * t118 * t487 ) - rtP
. Ii_32 * t5 * t118 * t487 ) - rtP . Ii_32 * t4 * t488 * t489 ) - rtP . Ii_32
* t5 * t488 * t489 ) + rtP . Ii_11 * ehrq52oenb [ 3 ] * t105 * ehrq52oenb [ 2
] * 0.75 ) + rtP . Ii_22 * ehrq52oenb [ 3 ] * t151 * ehrq52oenb [ 2 ] * 0.5 )
- rtP . Ii_33 * ehrq52oenb [ 3 ] * t151 * ehrq52oenb [ 2 ] * 0.5 ) - rtP .
Ii_33 * ehrq52oenb [ 3 ] * t105 * ehrq52oenb [ 2 ] * 0.75 ) - rtP . Ii_31 *
ehrq52oenb [ 3 ] * t155 * ehrq52oenb [ 2 ] * 0.5 ) - rtP . Ii_31 * ehrq52oenb
[ 3 ] * t210 * ehrq52oenb [ 2 ] * 1.5 ) - rtP . Ii_11 * ehrq52oenb [ 3 ] *
ehrq52oenb [ 5 ] * t118 * t487 * 0.5 ) + rtP . Ii_22 * ehrq52oenb [ 3 ] *
ehrq52oenb [ 5 ] * t118 * t487 ) - rtP . Ii_33 * ehrq52oenb [ 3 ] *
ehrq52oenb [ 5 ] * t118 * t487 * 0.5 ) - rtP . Ii_11 * ehrq52oenb [ 3 ] *
ehrq52oenb [ 5 ] * t488 * t489 * 0.5 ) + rtP . Ii_22 * ehrq52oenb [ 3 ] *
ehrq52oenb [ 5 ] * t488 * t489 ) - rtP . Ii_33 * ehrq52oenb [ 3 ] *
ehrq52oenb [ 5 ] * t488 * t489 * 0.5 ) + rtP . Ii_32 * ehrq52oenb [ 3 ] * t2
* t485 * ehrq52oenb [ 2 ] ) + rtP . Ii_32 * ehrq52oenb [ 3 ] * t3 * t486 *
ehrq52oenb [ 2 ] ) - rtP . Ii_32 * ehrq52oenb [ 3 ] * t118 * t487 *
ehrq52oenb [ 2 ] * 2.0 ) - rtP . Ii_32 * ehrq52oenb [ 3 ] * t488 * t489 *
ehrq52oenb [ 2 ] * 2.0 ) - rtP . Ii_11 * ehrq52oenb [ 5 ] * t118 * t487 *
ehrq52oenb [ 2 ] * 0.5 ) + rtP . Ii_22 * ehrq52oenb [ 5 ] * t118 * t487 *
ehrq52oenb [ 2 ] ) - rtP . Ii_33 * ehrq52oenb [ 5 ] * t118 * t487 *
ehrq52oenb [ 2 ] * 0.5 ) - rtP . Ii_11 * ehrq52oenb [ 5 ] * t488 * t489 *
ehrq52oenb [ 2 ] * 0.5 ) + rtP . Ii_22 * ehrq52oenb [ 5 ] * t488 * t489 *
ehrq52oenb [ 2 ] ) - rtP . Ii_33 * ehrq52oenb [ 5 ] * t488 * t489 *
ehrq52oenb [ 2 ] * 0.5 ) - rtP . Ii_11 * t2 * t4 * t105 * t486 * 0.5 ) + rtP
. Ii_11 * t3 * t4 * t105 * t485 * 0.5 ) - rtP . Ii_11 * t2 * t5 * t105 * t486
* 0.5 ) + rtP . Ii_11 * t3 * t5 * t105 * t485 * 0.5 ) - rtP . Ii_21 * t2 * t4
* t151 * t485 * 0.5 ) - rtP . Ii_21 * t2 * t5 * t151 * t485 * 0.5 ) - rtP .
Ii_21 * t3 * t4 * t151 * t486 * 0.5 ) - rtP . Ii_21 * t3 * t5 * t151 * t486 *
0.5 ) + rtP . Ii_33 * t2 * t4 * t105 * t486 * 0.5 ) - rtP . Ii_33 * t3 * t4 *
t105 * t485 * 0.5 ) + rtP . Ii_32 * t2 * t4 * t155 * t485 * 0.5 ) + rtP .
Ii_33 * t2 * t5 * t105 * t486 * 0.5 ) - rtP . Ii_33 * t3 * t5 * t105 * t485 *
0.5 ) + rtP . Ii_31 * t2 * t4 * t210 * t486 ) - rtP . Ii_31 * t3 * t4 * t210
* t485 ) + rtP . Ii_32 * t2 * t5 * t155 * t485 * 0.5 ) + rtP . Ii_31 * t2 *
t5 * t210 * t486 ) - rtP . Ii_31 * t3 * t5 * t210 * t485 ) + rtP . Ii_32 * t3
* t4 * t155 * t486 * 0.5 ) + rtP . Ii_32 * t3 * t5 * t155 * t486 * 0.5 ) -
rtP . Ii_11 * t4 * t118 * t105 * t488 * 0.125 ) - rtP . Ii_11 * t5 * t118 *
t105 * t488 * 0.125 ) - rtP . Ii_21 * t4 * t118 * t151 * t487 ) - rtP . Ii_21
* t5 * t118 * t151 * t487 ) + rtP . Ii_22 * t4 * t118 * t151 * t488 * 0.25 )
+ rtP . Ii_22 * t5 * t118 * t151 * t488 * 0.25 ) + rtP . Ii_11 * t23 * t118 *
t151 * t488 * 0.25 ) - rtP . Ii_33 * t4 * t118 * t151 * t488 * 0.25 ) + rtP .
Ii_33 * t4 * t118 * t105 * t488 * 0.125 ) - rtP . Ii_33 * t5 * t118 * t151 *
t488 * 0.25 ) - rtP . Ii_31 * t4 * t118 * t155 * t488 * 0.25 ) + rtP . Ii_32
* t4 * t118 * t155 * t487 ) + rtP . Ii_33 * t5 * t118 * t105 * t488 * 0.125 )
+ rtP . Ii_31 * t4 * t118 * t210 * t488 * 0.25 ) - rtP . Ii_31 * t5 * t118 *
t155 * t488 * 0.25 ) + rtP . Ii_32 * t5 * t118 * t155 * t487 ) + rtP . Ii_31
* t5 * t118 * t210 * t488 * 0.25 ) - rtP . Ii_33 * t23 * t118 * t151 * t488 *
0.25 ) - rtP . Ii_31 * t23 * t118 * t155 * t488 * 0.5 ) - rtP . Ii_11 * t2 *
t4 * t486 * t490 * 0.25 ) + rtP . Ii_11 * t3 * t4 * t485 * t490 * 0.25 ) -
rtP . Ii_11 * t2 * t5 * t486 * t490 * 0.25 ) + rtP . Ii_11 * t3 * t5 * t485 *
t490 * 0.25 ) - rtP . Ii_11 * t2 * t4 * t486 * t79 * 0.25 ) + rtP . Ii_11 *
t3 * t4 * t485 * t79 * 0.25 ) - rtP . Ii_11 * t2 * t5 * t486 * t79 * 0.25 ) +
rtP . Ii_11 * t3 * t5 * t485 * t79 * 0.25 ) + rtP . Ii_21 * t2 * t4 * t485 *
t490 * 0.25 ) + rtP . Ii_21 * t2 * t5 * t485 * t490 * 0.25 ) + rtP . Ii_21 *
t3 * t4 * t486 * t490 * 0.25 ) - rtP . Ii_21 * t2 * t4 * t485 * t79 * 0.75 )
+ rtP . Ii_21 * t3 * t5 * t486 * t490 * 0.25 ) - rtP . Ii_21 * t2 * t5 * t485
* t79 * 0.75 ) - rtP . Ii_21 * t3 * t4 * t486 * t79 * 0.75 ) - rtP . Ii_21 *
t3 * t5 * t486 * t79 * 0.75 ) + rtP . Ii_31 * t2 * t4 * t486 * t491 * 0.5 ) -
rtP . Ii_31 * t3 * t4 * t485 * t491 * 0.5 ) + rtP . Ii_32 * t2 * t4 * t485 *
t491 * 0.25 ) + rtP . Ii_31 * t2 * t4 * t486 * t492 * 0.5 ) + rtP . Ii_31 *
t2 * t5 * t486 * t491 * 0.5 ) - rtP . Ii_31 * t3 * t4 * t485 * t492 * 0.5 ) -
rtP . Ii_31 * t3 * t5 * t485 * t491 * 0.5 ) + rtP . Ii_32 * t2 * t4 * t485 *
t492 * 0.75 ) + rtP . Ii_32 * t2 * t5 * t485 * t491 * 0.25 ) + rtP . Ii_33 *
t2 * t4 * t486 * t490 * 0.25 ) - rtP . Ii_33 * t3 * t4 * t485 * t490 * 0.25 )
+ rtP . Ii_31 * t2 * t5 * t486 * t492 * 0.5 ) - rtP . Ii_31 * t3 * t5 * t485
* t492 * 0.5 ) + rtP . Ii_32 * t2 * t5 * t485 * t492 * 0.75 ) + rtP . Ii_32 *
t3 * t4 * t486 * t491 * 0.25 ) + rtP . Ii_33 * t2 * t5 * t486 * t490 * 0.25 )
- rtP . Ii_33 * t3 * t5 * t485 * t490 * 0.25 ) + rtP . Ii_32 * t3 * t4 * t486
* t492 * 0.75 ) + rtP . Ii_32 * t3 * t5 * t486 * t491 * 0.25 ) + rtP . Ii_32
* t3 * t5 * t486 * t492 * 0.75 ) + rtP . Ii_33 * t2 * t4 * t486 * t79 * 0.25
) - rtP . Ii_33 * t3 * t4 * t485 * t79 * 0.25 ) + rtP . Ii_33 * t2 * t5 *
t486 * t79 * 0.25 ) - rtP . Ii_33 * t3 * t5 * t485 * t79 * 0.25 ) - rtP .
Ii_11 * t4 * t118 * t488 * t490 * 0.25 ) - rtP . Ii_11 * t5 * t118 * t488 *
t490 * 0.25 ) - rtP . Ii_11 * t4 * t118 * t488 * t79 * 0.25 ) - rtP . Ii_11 *
t5 * t118 * t488 * t79 * 0.25 ) + rtP . Ii_21 * t4 * t118 * t487 * t490 *
0.125 ) + rtP . Ii_21 * t5 * t118 * t487 * t490 * 0.125 ) + rtP . Ii_22 * t4
* t118 * t488 * t490 ) - rtP . Ii_21 * t4 * t118 * t487 * t79 * 0.375 ) + rtP
. Ii_22 * t5 * t118 * t488 * t490 ) - rtP . Ii_21 * t5 * t118 * t487 * t79 *
0.375 ) - rtP . Ii_31 * t4 * t118 * t488 * t491 * 0.5 ) - rtP . Ii_32 * t4 *
t118 * t487 * t491 * 0.375 ) + rtP . Ii_31 * t4 * t118 * t488 * t492 * 0.5 )
- rtP . Ii_31 * t5 * t118 * t488 * t491 * 0.5 ) + rtP . Ii_32 * t4 * t118 *
t487 * t492 * 0.375 ) - rtP . Ii_32 * t5 * t118 * t487 * t491 * 0.375 ) - rtP
. Ii_33 * t4 * t118 * t488 * t490 * 0.75 ) + rtP . Ii_31 * t5 * t118 * t488 *
t492 * 0.5 ) + rtP . Ii_32 * t5 * t118 * t487 * t492 * 0.375 ) - rtP . Ii_33
* t5 * t118 * t488 * t490 * 0.75 ) + rtP . Ii_33 * t4 * t118 * t488 * t79 *
0.25 ) + rtP . Ii_33 * t5 * t118 * t488 * t79 * 0.25 ) + rtP . Ii_21 * t23 *
t118 * t487 * t490 * 0.5 ) - rtP . Ii_32 * t23 * t118 * t487 * t491 * 0.5 ) +
rtP . Ii_11 * t4 * t105 * t487 * t489 * 0.125 ) + rtP . Ii_11 * t5 * t105 *
t487 * t489 * 0.125 ) - rtP . Ii_21 * t4 * t151 * t488 * t489 ) - rtP . Ii_22
* t4 * t151 * t487 * t489 * 0.25 ) - rtP . Ii_21 * t5 * t151 * t488 * t489 )
- rtP . Ii_22 * t5 * t151 * t487 * t489 * 0.25 ) - rtP . Ii_11 * t23 * t151 *
t487 * t489 * 0.25 ) + rtP . Ii_33 * t4 * t151 * t487 * t489 * 0.25 ) - rtP .
Ii_33 * t4 * t105 * t487 * t489 * 0.125 ) + rtP . Ii_33 * t5 * t151 * t487 *
t489 * 0.25 ) + rtP . Ii_31 * t4 * t155 * t487 * t489 * 0.25 ) - rtP . Ii_33
* t5 * t105 * t487 * t489 * 0.125 ) - rtP . Ii_31 * t4 * t210 * t487 * t489 *
0.25 ) + rtP . Ii_31 * t5 * t155 * t487 * t489 * 0.25 ) - rtP . Ii_31 * t5 *
t210 * t487 * t489 * 0.25 ) + rtP . Ii_32 * t4 * t155 * t488 * t489 ) + rtP .
Ii_32 * t5 * t155 * t488 * t489 ) + rtP . Ii_33 * t23 * t151 * t487 * t489 *
0.25 ) + rtP . Ii_31 * t23 * t155 * t487 * t489 * 0.5 ) + rtP . Ii_11 * t4 *
t487 * t489 * t490 * 0.25 ) + rtP . Ii_11 * t5 * t487 * t489 * t490 * 0.25 )
+ rtP . Ii_11 * t4 * t487 * t489 * t79 * 0.25 ) + rtP . Ii_11 * t5 * t487 *
t489 * t79 * 0.25 ) + rtP . Ii_21 * t4 * t488 * t489 * t490 * 0.125 ) - rtP .
Ii_22 * t4 * t487 * t489 * t490 ) + rtP . Ii_21 * t5 * t488 * t489 * t490 *
0.125 ) - rtP . Ii_22 * t5 * t487 * t489 * t490 ) - rtP . Ii_21 * t4 * t488 *
t489 * t79 * 0.375 ) - rtP . Ii_21 * t5 * t488 * t489 * t79 * 0.375 ) + rtP .
Ii_31 * t4 * t487 * t489 * t491 * 0.5 ) - rtP . Ii_31 * t4 * t487 * t489 *
t492 * 0.5 ) + rtP . Ii_31 * t5 * t487 * t489 * t491 * 0.5 ) + rtP . Ii_33 *
t4 * t487 * t489 * t490 * 0.75 ) - rtP . Ii_31 * t5 * t487 * t489 * t492 *
0.5 ) - rtP . Ii_32 * t4 * t488 * t489 * t491 * 0.375 ) + rtP . Ii_33 * t5 *
t487 * t489 * t490 * 0.75 ) + rtP . Ii_32 * t4 * t488 * t489 * t492 * 0.375 )
- rtP . Ii_32 * t5 * t488 * t489 * t491 * 0.375 ) + rtP . Ii_32 * t5 * t488 *
t489 * t492 * 0.375 ) - rtP . Ii_33 * t4 * t487 * t489 * t79 * 0.25 ) - rtP .
Ii_33 * t5 * t487 * t489 * t79 * 0.25 ) + rtP . Ii_21 * t23 * t488 * t489 *
t490 * 0.5 ) - rtP . Ii_32 * t23 * t488 * t489 * t491 * 0.5 ) - rtP . Ii_11 *
ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t118 * t155 * t487 * 0.5 ) - rtP .
Ii_31 * ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t118 * t151 * t487 ) + rtP .
Ii_33 * ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t118 * t155 * t487 * 0.5 ) +
rtP . Ii_21 * ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t118 * t488 * t491 * 2.0
) + rtP . Ii_32 * ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t118 * t488 * t490 *
2.0 ) - rtP . Ii_11 * ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t155 * t488 *
t489 * 0.5 ) - rtP . Ii_31 * ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t151 *
t488 * t489 ) + rtP . Ii_33 * ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] * t155 *
t488 * t489 * 0.5 ) - rtP . Ii_21 * ehrq52oenb [ 3 ] * ehrq52oenb [ 5 ] *
t487 * t489 * t491 * 2.0 ) - rtP . Ii_32 * ehrq52oenb [ 3 ] * ehrq52oenb [ 5
] * t487 * t489 * t490 * 2.0 ) - rtP . Ii_11 * ehrq52oenb [ 3 ] * t2 * t105 *
t486 * ehrq52oenb [ 2 ] ) + rtP . Ii_11 * ehrq52oenb [ 3 ] * t3 * t105 * t485
* ehrq52oenb [ 2 ] ) - rtP . Ii_21 * ehrq52oenb [ 3 ] * t2 * t151 * t485 *
ehrq52oenb [ 2 ] ) - rtP . Ii_21 * ehrq52oenb [ 3 ] * t3 * t151 * t486 *
ehrq52oenb [ 2 ] ) + rtP . Ii_33 * ehrq52oenb [ 3 ] * t2 * t105 * t486 *
ehrq52oenb [ 2 ] ) - rtP . Ii_33 * ehrq52oenb [ 3 ] * t3 * t105 * t485 *
ehrq52oenb [ 2 ] ) + rtP . Ii_32 * ehrq52oenb [ 3 ] * t2 * t155 * t485 *
ehrq52oenb [ 2 ] ) + rtP . Ii_31 * ehrq52oenb [ 3 ] * t2 * t210 * t486 *
ehrq52oenb [ 2 ] * 2.0 ) - rtP . Ii_31 * ehrq52oenb [ 3 ] * t3 * t210 * t485
* ehrq52oenb [ 2 ] * 2.0 ) + rtP . Ii_32 * ehrq52oenb [ 3 ] * t3 * t155 *
t486 * ehrq52oenb [ 2 ] ) - rtP . Ii_11 * ehrq52oenb [ 3 ] * t118 * t105 *
t488 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ii_21 * ehrq52oenb [ 3 ] * t118 *
t151 * t487 * ehrq52oenb [ 2 ] * 2.0 ) + rtP . Ii_22 * ehrq52oenb [ 3 ] *
t118 * t151 * t488 * ehrq52oenb [ 2 ] * 0.5 ) - rtP . Ii_33 * ehrq52oenb [ 3
] * t118 * t151 * t488 * ehrq52oenb [ 2 ] * 0.5 ) + rtP . Ii_33 * ehrq52oenb
[ 3 ] * t118 * t105 * t488 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ii_31 *
ehrq52oenb [ 3 ] * t118 * t155 * t488 * ehrq52oenb [ 2 ] * 0.5 ) + rtP .
Ii_32 * ehrq52oenb [ 3 ] * t118 * t155 * t487 * ehrq52oenb [ 2 ] * 2.0 ) +
rtP . Ii_31 * ehrq52oenb [ 3 ] * t118 * t210 * t488 * ehrq52oenb [ 2 ] * 0.5
) - rtP . Ii_11 * ehrq52oenb [ 3 ] * t2 * t486 * t490 * ehrq52oenb [ 2 ] *
0.5 ) + rtP . Ii_11 * ehrq52oenb [ 3 ] * t3 * t485 * t490 * ehrq52oenb [ 2 ]
* 0.5 ) - rtP . Ii_11 * ehrq52oenb [ 3 ] * t2 * t486 * t79 * ehrq52oenb [ 2 ]
* 0.5 ) + rtP . Ii_11 * ehrq52oenb [ 3 ] * t3 * t485 * t79 * ehrq52oenb [ 2 ]
* 0.5 ) + rtP . Ii_21 * ehrq52oenb [ 3 ] * t2 * t485 * t490 * ehrq52oenb [ 2
] * 0.5 ) + rtP . Ii_21 * ehrq52oenb [ 3 ] * t3 * t486 * t490 * ehrq52oenb [
2 ] * 0.5 ) - rtP . Ii_21 * ehrq52oenb [ 3 ] * t2 * t485 * t79 * ehrq52oenb [
2 ] * 1.5 ) - rtP . Ii_21 * ehrq52oenb [ 3 ] * t3 * t486 * t79 * ehrq52oenb [
2 ] * 1.5 ) + rtP . Ii_31 * ehrq52oenb [ 3 ] * t2 * t486 * t491 * ehrq52oenb
[ 2 ] ) - rtP . Ii_31 * ehrq52oenb [ 3 ] * t3 * t485 * t491 * ehrq52oenb [ 2
] ) + rtP . Ii_32 * ehrq52oenb [ 3 ] * t2 * t485 * t491 * ehrq52oenb [ 2 ] *
0.5 ) + rtP . Ii_31 * ehrq52oenb [ 3 ] * t2 * t486 * t492 * ehrq52oenb [ 2 ]
) - rtP . Ii_31 * ehrq52oenb [ 3 ] * t3 * t485 * t492 * ehrq52oenb [ 2 ] ) +
rtP . Ii_32 * ehrq52oenb [ 3 ] * t2 * t485 * t492 * ehrq52oenb [ 2 ] * 1.5 )
+ rtP . Ii_33 * ehrq52oenb [ 3 ] * t2 * t486 * t490 * ehrq52oenb [ 2 ] * 0.5
) - rtP . Ii_33 * ehrq52oenb [ 3 ] * t3 * t485 * t490 * ehrq52oenb [ 2 ] *
0.5 ) + rtP . Ii_32 * ehrq52oenb [ 3 ] * t3 * t486 * t491 * ehrq52oenb [ 2 ]
* 0.5 ) + rtP . Ii_32 * ehrq52oenb [ 3 ] * t3 * t486 * t492 * ehrq52oenb [ 2
] * 1.5 ) + rtP . Ii_33 * ehrq52oenb [ 3 ] * t2 * t486 * t79 * ehrq52oenb [ 2
] * 0.5 ) - rtP . Ii_33 * ehrq52oenb [ 3 ] * t3 * t485 * t79 * ehrq52oenb [ 2
] * 0.5 ) - rtP . Ii_11 * ehrq52oenb [ 3 ] * t118 * t488 * t490 * ehrq52oenb
[ 2 ] * 0.5 ) - rtP . Ii_11 * ehrq52oenb [ 3 ] * t118 * t488 * t79 *
ehrq52oenb [ 2 ] * 0.5 ) + rtP . Ii_21 * ehrq52oenb [ 3 ] * t118 * t487 *
t490 * ehrq52oenb [ 2 ] * 0.25 ) + rtP . Ii_22 * ehrq52oenb [ 3 ] * t118 *
t488 * t490 * ehrq52oenb [ 2 ] * 2.0 ) - rtP . Ii_21 * ehrq52oenb [ 3 ] *
t118 * t487 * t79 * ehrq52oenb [ 2 ] * 0.75 ) - rtP . Ii_31 * ehrq52oenb [ 3
] * t118 * t488 * t491 * ehrq52oenb [ 2 ] ) - rtP . Ii_32 * ehrq52oenb [ 3 ]
* t118 * t487 * t491 * ehrq52oenb [ 2 ] * 0.75 ) + rtP . Ii_31 * ehrq52oenb [
3 ] * t118 * t488 * t492 * ehrq52oenb [ 2 ] ) + rtP . Ii_32 * ehrq52oenb [ 3
] * t118 * t487 * t492 * ehrq52oenb [ 2 ] * 0.75 ) - rtP . Ii_33 * ehrq52oenb
[ 3 ] * t118 * t488 * t490 * ehrq52oenb [ 2 ] * 1.5 ) + rtP . Ii_33 *
ehrq52oenb [ 3 ] * t118 * t488 * t79 * ehrq52oenb [ 2 ] * 0.5 ) + rtP . Ii_11
* ehrq52oenb [ 3 ] * t105 * t487 * t489 * ehrq52oenb [ 2 ] * 0.25 ) - rtP .
Ii_21 * ehrq52oenb [ 3 ] * t151 * t488 * t489 * ehrq52oenb [ 2 ] * 2.0 ) -
rtP . Ii_22 * ehrq52oenb [ 3 ] * t151 * t487 * t489 * ehrq52oenb [ 2 ] * 0.5
) + rtP . Ii_33 * ehrq52oenb [ 3 ] * t151 * t487 * t489 * ehrq52oenb [ 2 ] *
0.5 ) - rtP . Ii_33 * ehrq52oenb [ 3 ] * t105 * t487 * t489 * ehrq52oenb [ 2
] * 0.25 ) + rtP . Ii_31 * ehrq52oenb [ 3 ] * t155 * t487 * t489 * ehrq52oenb
[ 2 ] * 0.5 ) - rtP . Ii_31 * ehrq52oenb [ 3 ] * t210 * t487 * t489 *
ehrq52oenb [ 2 ] * 0.5 ) + rtP . Ii_32 * ehrq52oenb [ 3 ] * t155 * t488 *
t489 * ehrq52oenb [ 2 ] * 2.0 ) + rtP . Ii_11 * ehrq52oenb [ 3 ] * t487 *
t489 * t490 * ehrq52oenb [ 2 ] * 0.5 ) + rtP . Ii_11 * ehrq52oenb [ 3 ] *
t487 * t489 * t79 * ehrq52oenb [ 2 ] * 0.5 ) + rtP . Ii_21 * ehrq52oenb [ 3 ]
* t488 * t489 * t490 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Ii_22 * ehrq52oenb [
3 ] * t487 * t489 * t490 * ehrq52oenb [ 2 ] * 2.0 ) - rtP . Ii_21 *
ehrq52oenb [ 3 ] * t488 * t489 * t79 * ehrq52oenb [ 2 ] * 0.75 ) + rtP .
Ii_31 * ehrq52oenb [ 3 ] * t487 * t489 * t491 * ehrq52oenb [ 2 ] ) - rtP .
Ii_31 * ehrq52oenb [ 3 ] * t487 * t489 * t492 * ehrq52oenb [ 2 ] ) + rtP .
Ii_33 * ehrq52oenb [ 3 ] * t487 * t489 * t490 * ehrq52oenb [ 2 ] * 1.5 ) -
rtP . Ii_32 * ehrq52oenb [ 3 ] * t488 * t489 * t491 * ehrq52oenb [ 2 ] * 0.75
) + rtP . Ii_32 * ehrq52oenb [ 3 ] * t488 * t489 * t492 * ehrq52oenb [ 2 ] *
0.75 ) - rtP . Ii_33 * ehrq52oenb [ 3 ] * t487 * t489 * t79 * ehrq52oenb [ 2
] * 0.5 ) - rtP . Ii_11 * ehrq52oenb [ 5 ] * t118 * t155 * t487 * ehrq52oenb
[ 2 ] * 0.5 ) - rtP . Ii_31 * ehrq52oenb [ 5 ] * t118 * t151 * t487 *
ehrq52oenb [ 2 ] ) + rtP . Ii_33 * ehrq52oenb [ 5 ] * t118 * t155 * t487 *
ehrq52oenb [ 2 ] * 0.5 ) + rtP . Ii_21 * ehrq52oenb [ 5 ] * t118 * t488 *
t491 * ehrq52oenb [ 2 ] * 2.0 ) + rtP . Ii_32 * ehrq52oenb [ 5 ] * t118 *
t488 * t490 * ehrq52oenb [ 2 ] * 2.0 ) - rtP . Ii_11 * ehrq52oenb [ 5 ] *
t155 * t488 * t489 * ehrq52oenb [ 2 ] * 0.5 ) - rtP . Ii_31 * ehrq52oenb [ 5
] * t151 * t488 * t489 * ehrq52oenb [ 2 ] ) + rtP . Ii_33 * ehrq52oenb [ 5 ]
* t155 * t488 * t489 * ehrq52oenb [ 2 ] * 0.5 ) - rtP . Ii_21 * ehrq52oenb [
5 ] * t487 * t489 * t491 * ehrq52oenb [ 2 ] * 2.0 ) - rtP . Ii_32 *
ehrq52oenb [ 5 ] * t487 * t489 * t490 * ehrq52oenb [ 2 ] * 2.0 ; owi2j0naiy [
6 ] = ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( rtP . Io_11 * t4 * t156 * 0.375 + rtP . Constant_Value [ 1 ]
) + rtP . Io_11 * t8 * t156 * 0.375 ) + rtP . Io_22 * t4 * t159 * 0.25 ) +
rtP . Io_22 * t8 * t159 * 0.25 ) - rtP . Io_33 * t4 * t159 * 0.25 ) + rtP .
Io_11 * t27 * t159 * 0.25 ) - rtP . Io_33 * t4 * t156 * 0.375 ) - rtP . Io_31
* t4 * t211 * 0.25 ) - rtP . Io_31 * t4 * t212 * 0.75 ) - rtP . Io_33 * t8 *
t159 * 0.25 ) - rtP . Io_33 * t8 * t156 * 0.375 ) - rtP . Io_31 * t8 * t211 *
0.25 ) - rtP . Io_31 * t8 * t212 * 0.75 ) - rtP . Io_33 * t27 * t159 * 0.25 )
- rtP . Io_31 * t27 * t211 * 0.5 ) + rtP . Io_32 * t2 * t4 * t494 * 0.5 ) +
rtP . Io_32 * t3 * t4 * t495 * 0.5 ) + rtP . Io_32 * t2 * t8 * t494 * 0.5 ) +
rtP . Io_32 * t3 * t8 * t495 * 0.5 ) - rtP . Io_32 * t4 * t118 * t496 ) - rtP
. Io_32 * t8 * t118 * t496 ) - rtP . Io_32 * t4 * t489 * t497 ) - rtP . Io_32
* t8 * t489 * t497 ) + rtP . Io_11 * rtB . hkbmt1bwgv [ 9 ] * t156 *
ehrq52oenb [ 2 ] * 0.75 ) + rtP . Io_22 * rtB . hkbmt1bwgv [ 9 ] * t159 *
ehrq52oenb [ 2 ] * 0.5 ) - rtP . Io_33 * rtB . hkbmt1bwgv [ 9 ] * t159 *
ehrq52oenb [ 2 ] * 0.5 ) - rtP . Io_33 * rtB . hkbmt1bwgv [ 9 ] * t156 *
ehrq52oenb [ 2 ] * 0.75 ) - rtP . Io_31 * rtB . hkbmt1bwgv [ 9 ] * t211 *
ehrq52oenb [ 2 ] * 0.5 ) - rtP . Io_31 * rtB . hkbmt1bwgv [ 9 ] * t212 *
ehrq52oenb [ 2 ] * 1.5 ) - rtP . Io_11 * rtB . hkbmt1bwgv [ 9 ] * rtB .
hkbmt1bwgv [ 10 ] * t118 * t496 * 0.5 ) + rtP . Io_22 * rtB . hkbmt1bwgv [ 9
] * rtB . hkbmt1bwgv [ 10 ] * t118 * t496 ) - rtP . Io_33 * rtB . hkbmt1bwgv
[ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t118 * t496 * 0.5 ) - rtP . Io_11 * rtB .
hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t489 * t497 * 0.5 ) + rtP .
Io_22 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t489 * t497 ) -
rtP . Io_33 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t489 * t497
* 0.5 ) + rtP . Io_32 * rtB . hkbmt1bwgv [ 9 ] * t2 * t494 * ehrq52oenb [ 2 ]
) + rtP . Io_32 * rtB . hkbmt1bwgv [ 9 ] * t3 * t495 * ehrq52oenb [ 2 ] ) -
rtP . Io_32 * rtB . hkbmt1bwgv [ 9 ] * t118 * t496 * ehrq52oenb [ 2 ] * 2.0 )
- rtP . Io_32 * rtB . hkbmt1bwgv [ 9 ] * t489 * t497 * ehrq52oenb [ 2 ] * 2.0
) - rtP . Io_11 * rtB . hkbmt1bwgv [ 10 ] * t118 * t496 * ehrq52oenb [ 2 ] *
0.5 ) + rtP . Io_22 * rtB . hkbmt1bwgv [ 10 ] * t118 * t496 * ehrq52oenb [ 2
] ) - rtP . Io_33 * rtB . hkbmt1bwgv [ 10 ] * t118 * t496 * ehrq52oenb [ 2 ]
* 0.5 ) - rtP . Io_11 * rtB . hkbmt1bwgv [ 10 ] * t489 * t497 * ehrq52oenb [
2 ] * 0.5 ) + rtP . Io_22 * rtB . hkbmt1bwgv [ 10 ] * t489 * t497 *
ehrq52oenb [ 2 ] ) - rtP . Io_33 * rtB . hkbmt1bwgv [ 10 ] * t489 * t497 *
ehrq52oenb [ 2 ] * 0.5 ) - rtP . Io_11 * t2 * t4 * t156 * t495 * 0.5 ) + rtP
. Io_11 * t3 * t4 * t156 * t494 * 0.5 ) - rtP . Io_11 * t2 * t8 * t156 * t495
* 0.5 ) + rtP . Io_11 * t3 * t8 * t156 * t494 * 0.5 ) - rtP . Io_21 * t2 * t4
* t159 * t494 * 0.5 ) - rtP . Io_21 * t3 * t4 * t159 * t495 * 0.5 ) - rtP .
Io_21 * t2 * t8 * t159 * t494 * 0.5 ) - rtP . Io_21 * t3 * t8 * t159 * t495 *
0.5 ) + rtP . Io_33 * t2 * t4 * t156 * t495 * 0.5 ) - rtP . Io_33 * t3 * t4 *
t156 * t494 * 0.5 ) + rtP . Io_32 * t2 * t4 * t211 * t494 * 0.5 ) + rtP .
Io_31 * t2 * t4 * t212 * t495 ) - rtP . Io_31 * t3 * t4 * t212 * t494 ) + rtP
. Io_32 * t3 * t4 * t211 * t495 * 0.5 ) + rtP . Io_33 * t2 * t8 * t156 * t495
* 0.5 ) - rtP . Io_33 * t3 * t8 * t156 * t494 * 0.5 ) + rtP . Io_32 * t2 * t8
* t211 * t494 * 0.5 ) + rtP . Io_31 * t2 * t8 * t212 * t495 ) - rtP . Io_31 *
t3 * t8 * t212 * t494 ) + rtP . Io_32 * t3 * t8 * t211 * t495 * 0.5 ) - rtP .
Io_11 * t4 * t118 * t156 * t497 * 0.125 ) - rtP . Io_11 * t8 * t118 * t156 *
t497 * 0.125 ) - rtP . Io_21 * t4 * t118 * t159 * t496 ) + rtP . Io_22 * t4 *
t118 * t159 * t497 * 0.25 ) - rtP . Io_21 * t8 * t118 * t159 * t496 ) + rtP .
Io_22 * t8 * t118 * t159 * t497 * 0.25 ) - rtP . Io_33 * t4 * t118 * t159 *
t497 * 0.25 ) + rtP . Io_11 * t27 * t118 * t159 * t497 * 0.25 ) + rtP . Io_33
* t4 * t118 * t156 * t497 * 0.125 ) - rtP . Io_31 * t4 * t118 * t211 * t497 *
0.25 ) + rtP . Io_32 * t4 * t118 * t211 * t496 ) + rtP . Io_31 * t4 * t118 *
t212 * t497 * 0.25 ) - rtP . Io_33 * t8 * t118 * t159 * t497 * 0.25 ) + rtP .
Io_33 * t8 * t118 * t156 * t497 * 0.125 ) - rtP . Io_31 * t8 * t118 * t211 *
t497 * 0.25 ) + rtP . Io_32 * t8 * t118 * t211 * t496 ) + rtP . Io_31 * t8 *
t118 * t212 * t497 * 0.25 ) - rtP . Io_33 * t27 * t118 * t159 * t497 * 0.25 )
- rtP . Io_31 * t27 * t118 * t211 * t497 * 0.5 ) - rtP . Io_11 * t2 * t4 *
t495 * t498 * 0.25 ) + rtP . Io_11 * t3 * t4 * t494 * t498 * 0.25 ) - rtP .
Io_11 * t2 * t4 * t495 * t89 * 0.25 ) + rtP . Io_11 * t3 * t4 * t494 * t89 *
0.25 ) - rtP . Io_11 * t2 * t8 * t495 * t498 * 0.25 ) + rtP . Io_11 * t3 * t8
* t494 * t498 * 0.25 ) - rtP . Io_11 * t2 * t8 * t495 * t89 * 0.25 ) + rtP .
Io_11 * t3 * t8 * t494 * t89 * 0.25 ) + rtP . Io_21 * t2 * t4 * t494 * t498 *
0.25 ) + rtP . Io_21 * t3 * t4 * t495 * t498 * 0.25 ) - rtP . Io_21 * t2 * t4
* t494 * t89 * 0.75 ) + rtP . Io_21 * t2 * t8 * t494 * t498 * 0.25 ) - rtP .
Io_21 * t3 * t4 * t495 * t89 * 0.75 ) + rtP . Io_21 * t3 * t8 * t495 * t498 *
0.25 ) - rtP . Io_21 * t2 * t8 * t494 * t89 * 0.75 ) - rtP . Io_21 * t3 * t8
* t495 * t89 * 0.75 ) + rtP . Io_31 * t2 * t4 * t495 * t499 * 0.5 ) - rtP .
Io_31 * t3 * t4 * t494 * t499 * 0.5 ) + rtP . Io_32 * t2 * t4 * t494 * t499 *
0.25 ) + rtP . Io_31 * t2 * t4 * t495 * t500 * 0.5 ) - rtP . Io_31 * t3 * t4
* t494 * t500 * 0.5 ) + rtP . Io_32 * t2 * t4 * t494 * t500 * 0.75 ) + rtP .
Io_33 * t2 * t4 * t495 * t498 * 0.25 ) - rtP . Io_33 * t3 * t4 * t494 * t498
* 0.25 ) + rtP . Io_32 * t3 * t4 * t495 * t499 * 0.25 ) + rtP . Io_32 * t3 *
t4 * t495 * t500 * 0.75 ) + rtP . Io_31 * t2 * t8 * t495 * t499 * 0.5 ) - rtP
. Io_31 * t3 * t8 * t494 * t499 * 0.5 ) + rtP . Io_32 * t2 * t8 * t494 * t499
* 0.25 ) + rtP . Io_33 * t2 * t4 * t495 * t89 * 0.25 ) - rtP . Io_33 * t3 *
t4 * t494 * t89 * 0.25 ) + rtP . Io_31 * t2 * t8 * t495 * t500 * 0.5 ) - rtP
. Io_31 * t3 * t8 * t494 * t500 * 0.5 ) + rtP . Io_32 * t2 * t8 * t494 * t500
* 0.75 ) + rtP . Io_33 * t2 * t8 * t495 * t498 * 0.25 ) - rtP . Io_33 * t3 *
t8 * t494 * t498 * 0.25 ) + rtP . Io_32 * t3 * t8 * t495 * t499 * 0.25 ) +
rtP . Io_32 * t3 * t8 * t495 * t500 * 0.75 ) + rtP . Io_33 * t2 * t8 * t495 *
t89 * 0.25 ) - rtP . Io_33 * t3 * t8 * t494 * t89 * 0.25 ) - rtP . Io_11 * t4
* t118 * t497 * t498 * 0.25 ) - rtP . Io_11 * t4 * t118 * t497 * t89 * 0.25 )
- rtP . Io_11 * t8 * t118 * t497 * t498 * 0.25 ) - rtP . Io_11 * t8 * t118 *
t497 * t89 * 0.25 ) + rtP . Io_21 * t4 * t118 * t496 * t498 * 0.125 ) + rtP .
Io_22 * t4 * t118 * t497 * t498 ) - rtP . Io_21 * t4 * t118 * t496 * t89 *
0.375 ) + rtP . Io_21 * t8 * t118 * t496 * t498 * 0.125 ) + rtP . Io_22 * t8
* t118 * t497 * t498 ) - rtP . Io_21 * t8 * t118 * t496 * t89 * 0.375 ) - rtP
. Io_31 * t4 * t118 * t497 * t499 * 0.5 ) - rtP . Io_32 * t4 * t118 * t496 *
t499 * 0.375 ) + rtP . Io_31 * t4 * t118 * t497 * t500 * 0.5 ) + rtP . Io_32
* t4 * t118 * t496 * t500 * 0.375 ) - rtP . Io_33 * t4 * t118 * t497 * t498 *
0.75 ) - rtP . Io_31 * t8 * t118 * t497 * t499 * 0.5 ) - rtP . Io_32 * t8 *
t118 * t496 * t499 * 0.375 ) + rtP . Io_33 * t4 * t118 * t497 * t89 * 0.25 )
+ rtP . Io_31 * t8 * t118 * t497 * t500 * 0.5 ) + rtP . Io_32 * t8 * t118 *
t496 * t500 * 0.375 ) - rtP . Io_33 * t8 * t118 * t497 * t498 * 0.75 ) + rtP
. Io_33 * t8 * t118 * t497 * t89 * 0.25 ) + rtP . Io_21 * t27 * t118 * t496 *
t498 * 0.5 ) - rtP . Io_32 * t27 * t118 * t496 * t499 * 0.5 ) + rtP . Io_11 *
t4 * t156 * t489 * t496 * 0.125 ) + rtP . Io_11 * t8 * t156 * t489 * t496 *
0.125 ) - rtP . Io_21 * t4 * t159 * t489 * t497 ) - rtP . Io_22 * t4 * t159 *
t489 * t496 * 0.25 ) - rtP . Io_21 * t8 * t159 * t489 * t497 ) - rtP . Io_22
* t8 * t159 * t489 * t496 * 0.25 ) + rtP . Io_33 * t4 * t159 * t489 * t496 *
0.25 ) - rtP . Io_11 * t27 * t159 * t489 * t496 * 0.25 ) - rtP . Io_33 * t4 *
t156 * t489 * t496 * 0.125 ) + rtP . Io_31 * t4 * t211 * t489 * t496 * 0.25 )
- rtP . Io_31 * t4 * t212 * t489 * t496 * 0.25 ) + rtP . Io_32 * t4 * t211 *
t489 * t497 ) + rtP . Io_33 * t8 * t159 * t489 * t496 * 0.25 ) - rtP . Io_33
* t8 * t156 * t489 * t496 * 0.125 ) + rtP . Io_31 * t8 * t211 * t489 * t496 *
0.25 ) - rtP . Io_31 * t8 * t212 * t489 * t496 * 0.25 ) + rtP . Io_32 * t8 *
t211 * t489 * t497 ) + rtP . Io_33 * t27 * t159 * t489 * t496 * 0.25 ) + rtP
. Io_31 * t27 * t211 * t489 * t496 * 0.5 ) + rtP . Io_11 * t4 * t489 * t496 *
t498 * 0.25 ) + rtP . Io_11 * t4 * t489 * t496 * t89 * 0.25 ) + rtP . Io_11 *
t8 * t489 * t496 * t498 * 0.25 ) + rtP . Io_11 * t8 * t489 * t496 * t89 *
0.25 ) + rtP . Io_21 * t4 * t489 * t497 * t498 * 0.125 ) - rtP . Io_22 * t4 *
t489 * t496 * t498 ) - rtP . Io_21 * t4 * t489 * t497 * t89 * 0.375 ) + rtP .
Io_21 * t8 * t489 * t497 * t498 * 0.125 ) - rtP . Io_22 * t8 * t489 * t496 *
t498 ) - rtP . Io_21 * t8 * t489 * t497 * t89 * 0.375 ) + rtP . Io_31 * t4 *
t489 * t496 * t499 * 0.5 ) - rtP . Io_31 * t4 * t489 * t496 * t500 * 0.5 ) +
rtP . Io_33 * t4 * t489 * t496 * t498 * 0.75 ) - rtP . Io_32 * t4 * t489 *
t497 * t499 * 0.375 ) + rtP . Io_32 * t4 * t489 * t497 * t500 * 0.375 ) + rtP
. Io_31 * t8 * t489 * t496 * t499 * 0.5 ) - rtP . Io_33 * t4 * t489 * t496 *
t89 * 0.25 ) - rtP . Io_31 * t8 * t489 * t496 * t500 * 0.5 ) + rtP . Io_33 *
t8 * t489 * t496 * t498 * 0.75 ) - rtP . Io_32 * t8 * t489 * t497 * t499 *
0.375 ) + rtP . Io_32 * t8 * t489 * t497 * t500 * 0.375 ) - rtP . Io_33 * t8
* t489 * t496 * t89 * 0.25 ) + rtP . Io_21 * t27 * t489 * t497 * t498 * 0.5 )
- rtP . Io_32 * t27 * t489 * t497 * t499 * 0.5 ) - rtP . Io_11 * rtB .
hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t118 * t211 * t496 * 0.5 ) - rtP
. Io_31 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t118 * t159 *
t496 ) + rtP . Io_33 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] *
t118 * t211 * t496 * 0.5 ) + rtP . Io_21 * rtB . hkbmt1bwgv [ 9 ] * rtB .
hkbmt1bwgv [ 10 ] * t118 * t497 * t499 * 2.0 ) + rtP . Io_32 * rtB .
hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t118 * t497 * t498 * 2.0 ) - rtP
. Io_11 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t211 * t489 *
t497 * 0.5 ) - rtP . Io_31 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ]
* t159 * t489 * t497 ) + rtP . Io_33 * rtB . hkbmt1bwgv [ 9 ] * rtB .
hkbmt1bwgv [ 10 ] * t211 * t489 * t497 * 0.5 ) - rtP . Io_21 * rtB .
hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t489 * t496 * t499 * 2.0 ) - rtP
. Io_32 * rtB . hkbmt1bwgv [ 9 ] * rtB . hkbmt1bwgv [ 10 ] * t489 * t496 *
t498 * 2.0 ) - rtP . Io_11 * rtB . hkbmt1bwgv [ 9 ] * t2 * t156 * t495 *
ehrq52oenb [ 2 ] ) + rtP . Io_11 * rtB . hkbmt1bwgv [ 9 ] * t3 * t156 * t494
* ehrq52oenb [ 2 ] ) - rtP . Io_21 * rtB . hkbmt1bwgv [ 9 ] * t2 * t159 *
t494 * ehrq52oenb [ 2 ] ) - rtP . Io_21 * rtB . hkbmt1bwgv [ 9 ] * t3 * t159
* t495 * ehrq52oenb [ 2 ] ) + rtP . Io_33 * rtB . hkbmt1bwgv [ 9 ] * t2 *
t156 * t495 * ehrq52oenb [ 2 ] ) - rtP . Io_33 * rtB . hkbmt1bwgv [ 9 ] * t3
* t156 * t494 * ehrq52oenb [ 2 ] ) + rtP . Io_32 * rtB . hkbmt1bwgv [ 9 ] *
t2 * t211 * t494 * ehrq52oenb [ 2 ] ) + rtP . Io_31 * rtB . hkbmt1bwgv [ 9 ]
* t2 * t212 * t495 * ehrq52oenb [ 2 ] * 2.0 ) - rtP . Io_31 * rtB .
hkbmt1bwgv [ 9 ] * t3 * t212 * t494 * ehrq52oenb [ 2 ] * 2.0 ) + rtP . Io_32
* rtB . hkbmt1bwgv [ 9 ] * t3 * t211 * t495 * ehrq52oenb [ 2 ] ) - rtP .
Io_11 * rtB . hkbmt1bwgv [ 9 ] * t118 * t156 * t497 * ehrq52oenb [ 2 ] * 0.25
) - rtP . Io_21 * rtB . hkbmt1bwgv [ 9 ] * t118 * t159 * t496 * ehrq52oenb [
2 ] * 2.0 ) + rtP . Io_22 * rtB . hkbmt1bwgv [ 9 ] * t118 * t159 * t497 *
ehrq52oenb [ 2 ] * 0.5 ) - rtP . Io_33 * rtB . hkbmt1bwgv [ 9 ] * t118 * t159
* t497 * ehrq52oenb [ 2 ] * 0.5 ) + rtP . Io_33 * rtB . hkbmt1bwgv [ 9 ] *
t118 * t156 * t497 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Io_31 * rtB .
hkbmt1bwgv [ 9 ] * t118 * t211 * t497 * ehrq52oenb [ 2 ] * 0.5 ) + rtP .
Io_32 * rtB . hkbmt1bwgv [ 9 ] * t118 * t211 * t496 * ehrq52oenb [ 2 ] * 2.0
) + rtP . Io_31 * rtB . hkbmt1bwgv [ 9 ] * t118 * t212 * t497 * ehrq52oenb [
2 ] * 0.5 ) - rtP . Io_11 * rtB . hkbmt1bwgv [ 9 ] * t2 * t495 * t498 *
ehrq52oenb [ 2 ] * 0.5 ) + rtP . Io_11 * rtB . hkbmt1bwgv [ 9 ] * t3 * t494 *
t498 * ehrq52oenb [ 2 ] * 0.5 ) - rtP . Io_11 * rtB . hkbmt1bwgv [ 9 ] * t2 *
t495 * t89 * ehrq52oenb [ 2 ] * 0.5 ) + rtP . Io_11 * rtB . hkbmt1bwgv [ 9 ]
* t3 * t494 * t89 * ehrq52oenb [ 2 ] * 0.5 ) + rtP . Io_21 * rtB . hkbmt1bwgv
[ 9 ] * t2 * t494 * t498 * ehrq52oenb [ 2 ] * 0.5 ) + rtP . Io_21 * rtB .
hkbmt1bwgv [ 9 ] * t3 * t495 * t498 * ehrq52oenb [ 2 ] * 0.5 ) - rtP . Io_21
* rtB . hkbmt1bwgv [ 9 ] * t2 * t494 * t89 * ehrq52oenb [ 2 ] * 1.5 ) - rtP .
Io_21 * rtB . hkbmt1bwgv [ 9 ] * t3 * t495 * t89 * ehrq52oenb [ 2 ] * 1.5 ) +
rtP . Io_31 * rtB . hkbmt1bwgv [ 9 ] * t2 * t495 * t499 * ehrq52oenb [ 2 ] )
- rtP . Io_31 * rtB . hkbmt1bwgv [ 9 ] * t3 * t494 * t499 * ehrq52oenb [ 2 ]
) + rtP . Io_32 * rtB . hkbmt1bwgv [ 9 ] * t2 * t494 * t499 * ehrq52oenb [ 2
] * 0.5 ) + rtP . Io_31 * rtB . hkbmt1bwgv [ 9 ] * t2 * t495 * t500 *
ehrq52oenb [ 2 ] ) - rtP . Io_31 * rtB . hkbmt1bwgv [ 9 ] * t3 * t494 * t500
* ehrq52oenb [ 2 ] ) + rtP . Io_32 * rtB . hkbmt1bwgv [ 9 ] * t2 * t494 *
t500 * ehrq52oenb [ 2 ] * 1.5 ) + rtP . Io_33 * rtB . hkbmt1bwgv [ 9 ] * t2 *
t495 * t498 * ehrq52oenb [ 2 ] * 0.5 ) - rtP . Io_33 * rtB . hkbmt1bwgv [ 9 ]
* t3 * t494 * t498 * ehrq52oenb [ 2 ] * 0.5 ) + rtP . Io_32 * rtB .
hkbmt1bwgv [ 9 ] * t3 * t495 * t499 * ehrq52oenb [ 2 ] * 0.5 ) + rtP . Io_32
* rtB . hkbmt1bwgv [ 9 ] * t3 * t495 * t500 * ehrq52oenb [ 2 ] * 1.5 ) + rtP
. Io_33 * rtB . hkbmt1bwgv [ 9 ] * t2 * t495 * t89 * ehrq52oenb [ 2 ] * 0.5 )
- rtP . Io_33 * rtB . hkbmt1bwgv [ 9 ] * t3 * t494 * t89 * ehrq52oenb [ 2 ] *
0.5 ) - rtP . Io_11 * rtB . hkbmt1bwgv [ 9 ] * t118 * t497 * t498 *
ehrq52oenb [ 2 ] * 0.5 ) - rtP . Io_11 * rtB . hkbmt1bwgv [ 9 ] * t118 * t497
* t89 * ehrq52oenb [ 2 ] * 0.5 ) + rtP . Io_21 * rtB . hkbmt1bwgv [ 9 ] *
t118 * t496 * t498 * ehrq52oenb [ 2 ] * 0.25 ) + rtP . Io_22 * rtB .
hkbmt1bwgv [ 9 ] * t118 * t497 * t498 * ehrq52oenb [ 2 ] * 2.0 ) - rtP .
Io_21 * rtB . hkbmt1bwgv [ 9 ] * t118 * t496 * t89 * ehrq52oenb [ 2 ] * 0.75
) - rtP . Io_31 * rtB . hkbmt1bwgv [ 9 ] * t118 * t497 * t499 * ehrq52oenb [
2 ] ) - rtP . Io_32 * rtB . hkbmt1bwgv [ 9 ] * t118 * t496 * t499 *
ehrq52oenb [ 2 ] * 0.75 ) + rtP . Io_31 * rtB . hkbmt1bwgv [ 9 ] * t118 *
t497 * t500 * ehrq52oenb [ 2 ] ) + rtP . Io_32 * rtB . hkbmt1bwgv [ 9 ] *
t118 * t496 * t500 * ehrq52oenb [ 2 ] * 0.75 ) - rtP . Io_33 * rtB .
hkbmt1bwgv [ 9 ] * t118 * t497 * t498 * ehrq52oenb [ 2 ] * 1.5 ) + rtP .
Io_33 * rtB . hkbmt1bwgv [ 9 ] * t118 * t497 * t89 * ehrq52oenb [ 2 ] * 0.5 )
+ rtP . Io_11 * rtB . hkbmt1bwgv [ 9 ] * t156 * t489 * t496 * ehrq52oenb [ 2
] * 0.25 ) - rtP . Io_21 * rtB . hkbmt1bwgv [ 9 ] * t159 * t489 * t497 *
ehrq52oenb [ 2 ] * 2.0 ) - rtP . Io_22 * rtB . hkbmt1bwgv [ 9 ] * t159 * t489
* t496 * ehrq52oenb [ 2 ] * 0.5 ) + rtP . Io_33 * rtB . hkbmt1bwgv [ 9 ] *
t159 * t489 * t496 * ehrq52oenb [ 2 ] * 0.5 ) - rtP . Io_33 * rtB .
hkbmt1bwgv [ 9 ] * t156 * t489 * t496 * ehrq52oenb [ 2 ] * 0.25 ) + rtP .
Io_31 * rtB . hkbmt1bwgv [ 9 ] * t211 * t489 * t496 * ehrq52oenb [ 2 ] * 0.5
) - rtP . Io_31 * rtB . hkbmt1bwgv [ 9 ] * t212 * t489 * t496 * ehrq52oenb [
2 ] * 0.5 ) + rtP . Io_32 * rtB . hkbmt1bwgv [ 9 ] * t211 * t489 * t497 *
ehrq52oenb [ 2 ] * 2.0 ) + rtP . Io_11 * rtB . hkbmt1bwgv [ 9 ] * t489 * t496
* t498 * ehrq52oenb [ 2 ] * 0.5 ) + rtP . Io_11 * rtB . hkbmt1bwgv [ 9 ] *
t489 * t496 * t89 * ehrq52oenb [ 2 ] * 0.5 ) + rtP . Io_21 * rtB . hkbmt1bwgv
[ 9 ] * t489 * t497 * t498 * ehrq52oenb [ 2 ] * 0.25 ) - rtP . Io_22 * rtB .
hkbmt1bwgv [ 9 ] * t489 * t496 * t498 * ehrq52oenb [ 2 ] * 2.0 ) - rtP .
Io_21 * rtB . hkbmt1bwgv [ 9 ] * t489 * t497 * t89 * ehrq52oenb [ 2 ] * 0.75
) + rtP . Io_31 * rtB . hkbmt1bwgv [ 9 ] * t489 * t496 * t499 * ehrq52oenb [
2 ] ) - rtP . Io_31 * rtB . hkbmt1bwgv [ 9 ] * t489 * t496 * t500 *
ehrq52oenb [ 2 ] ) + rtP . Io_33 * rtB . hkbmt1bwgv [ 9 ] * t489 * t496 *
t498 * ehrq52oenb [ 2 ] * 1.5 ) - rtP . Io_32 * rtB . hkbmt1bwgv [ 9 ] * t489
* t497 * t499 * ehrq52oenb [ 2 ] * 0.75 ) + rtP . Io_32 * rtB . hkbmt1bwgv [
9 ] * t489 * t497 * t500 * ehrq52oenb [ 2 ] * 0.75 ) - rtP . Io_33 * rtB .
hkbmt1bwgv [ 9 ] * t489 * t496 * t89 * ehrq52oenb [ 2 ] * 0.5 ) - rtP . Io_11
* rtB . hkbmt1bwgv [ 10 ] * t118 * t211 * t496 * ehrq52oenb [ 2 ] * 0.5 ) -
rtP . Io_31 * rtB . hkbmt1bwgv [ 10 ] * t118 * t159 * t496 * ehrq52oenb [ 2 ]
) + rtP . Io_33 * rtB . hkbmt1bwgv [ 10 ] * t118 * t211 * t496 * ehrq52oenb [
2 ] * 0.5 ) + rtP . Io_21 * rtB . hkbmt1bwgv [ 10 ] * t118 * t497 * t499 *
ehrq52oenb [ 2 ] * 2.0 ) + rtP . Io_32 * rtB . hkbmt1bwgv [ 10 ] * t118 *
t497 * t498 * ehrq52oenb [ 2 ] * 2.0 ) - rtP . Io_11 * rtB . hkbmt1bwgv [ 10
] * t211 * t489 * t497 * ehrq52oenb [ 2 ] * 0.5 ) - rtP . Io_31 * rtB .
hkbmt1bwgv [ 10 ] * t159 * t489 * t497 * ehrq52oenb [ 2 ] ) + rtP . Io_33 *
rtB . hkbmt1bwgv [ 10 ] * t211 * t489 * t497 * ehrq52oenb [ 2 ] * 0.5 ) - rtP
. Io_21 * rtB . hkbmt1bwgv [ 10 ] * t489 * t496 * t499 * ehrq52oenb [ 2 ] *
2.0 ) - rtP . Io_32 * rtB . hkbmt1bwgv [ 10 ] * t489 * t496 * t498 *
ehrq52oenb [ 2 ] * 2.0 ; owi2j0naiy [ 7 ] = ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( rtP
. Constant_Value [ 2 ] - rtP . Ir_31 * t4 * t507 ) + rtP . Ir_32 * t2 * t4 *
t503 ) - rtP . Ir_31 * t3 * t4 * t507 ) - rtP . Ir_31 * t3 * t4 * t509 ) +
rtP . Ir_22 * t4 * t504 * t506 ) - rtP . Ir_22 * t4 * t504 * t508 ) + rtP .
Ir_31 * t4 * t503 * t505 * 3.0 ) - rtP . Ir_31 * t4 * t508 * t509 ) - rtP .
Ir_31 * t17 * t503 * t506 ) + rtP . Ir_31 * t17 * t505 * t506 ) + rtP . Ir_22
* ehrq52oenb [ 7 ] * t2 * t3 * ehrq52oenb [ 2 ] * 2.0 ) + rtP . Ir_21 *
ehrq52oenb [ 7 ] * t502 * t506 * ehrq52oenb [ 2 ] * 2.0 ) - rtP . Ir_21 *
ehrq52oenb [ 7 ] * t502 * t508 * ehrq52oenb [ 2 ] * 2.0 ) + rtP . Ir_32 *
ehrq52oenb [ 7 ] * t504 * t506 * ehrq52oenb [ 2 ] * 2.0 ) - rtP . Ir_32 *
ehrq52oenb [ 7 ] * t504 * t508 * ehrq52oenb [ 2 ] * 2.0 ) - rtP . Ir_32 * t2
* t3 * t4 * t505 * 4.0 ) + rtP . Ir_21 * t2 * t3 * t17 * t504 ) - rtP . Ir_32
* t2 * t3 * t17 * t502 ) + rtP . Ir_11 * t3 * t4 * t503 * t504 ) - rtP .
Ir_21 * t2 * t4 * t502 * t504 ) - rtP . Ir_21 * t2 * t4 * t503 * t504 * 2.0 )
+ rtP . Ir_21 * t2 * t4 * t504 * t505 ) - rtP . Ir_31 * t3 * t4 * t502 * t503
) + rtP . Ir_32 * t2 * t4 * t502 * t503 ) + rtP . Ir_31 * t3 * t4 * t502 *
t505 ) - rtP . Ir_32 * t2 * t4 * t502 * t505 * 2.0 ) + rtP . Ir_31 * t3 * t4
* t503 * t505 * 6.0 ) - rtP . Ir_33 * t3 * t4 * t503 * t504 ) + rtP . Ir_11 *
t4 * t502 * t503 * t504 ) - rtP . Ir_11 * t4 * t502 * t504 * t505 ) - rtP .
Ir_11 * t4 * t503 * t504 * t506 ) + rtP . Ir_11 * t4 * t503 * t504 * t508 ) +
rtP . Ir_22 * t4 * t502 * t504 * t506 ) + rtP . Ir_11 * t17 * t502 * t504 *
t506 ) - rtP . Ir_33 * t4 * t502 * t503 * t504 * 2.0 ) - rtP . Ir_31 * t4 *
t502 * t505 * t506 * 2.0 ) + rtP . Ir_31 * t4 * t502 * t505 * t508 * 2.0 ) +
rtP . Ir_31 * t4 * t503 * t505 * t508 * 3.0 ) - rtP . Ir_33 * t4 * t504 *
t505 * t506 ) + rtP . Ir_33 * t4 * t504 * t505 * t508 ) - rtP . Ir_33 * t17 *
t502 * t504 * t506 ) - rtP . Ir_11 * ehrq52oenb [ 7 ] * t2 * t3 * t503 *
ehrq52oenb [ 2 ] * 2.0 ) - rtP . Ir_33 * ehrq52oenb [ 7 ] * t2 * t3 * t505 *
ehrq52oenb [ 2 ] * 2.0 ) - rtP . Ir_21 * t2 * t3 * t4 * t502 * t504 * 4.0 ) -
rtP . Ir_21 * t2 * t3 * t4 * t503 * t504 * 2.0 ) + rtP . Ir_21 * t2 * t3 * t4
* t504 * t505 ) - rtP . Ir_32 * t2 * t3 * t4 * t502 * t505 * 3.0 ) + rtP .
Ir_11 * t3 * t4 * t502 * t503 * t504 * 2.0 ) - rtP . Ir_11 * t3 * t4 * t502 *
t504 * t505 * 2.0 ) - rtP . Ir_33 * t3 * t4 * t502 * t503 * t504 * 2.0 ) +
rtP . Ir_33 * t3 * t4 * t502 * t504 * t505 * 2.0 ) + rtP . Ir_11 * t4 * t502
* t503 * t504 * t508 ) - rtP . Ir_11 * t4 * t502 * t504 * t505 * t508 ) + rtP
. Ir_33 * t4 * t502 * t504 * t505 * t508 * 2.0 ) - rtP . Ir_31 * ehrq52oenb [
7 ] * t2 * t3 * t502 * t504 * ehrq52oenb [ 2 ] * 4.0 ; owi2j0naiy [ 8 ] = ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( rtP . Constant_Value [ 3 ] - rtP . Il_31 * t4 *
t514 ) + rtP . Il_32 * t2 * t4 * t511 ) - rtP . Il_31 * t3 * t4 * t514 ) -
rtP . Il_31 * t3 * t4 * t515 ) + rtP . Il_22 * t4 * t506 * t512 ) - rtP .
Il_22 * t4 * t508 * t512 ) - rtP . Il_31 * t4 * t508 * t515 ) + rtP . Il_31 *
t4 * t511 * t513 * 3.0 ) - rtP . Il_31 * t15 * t506 * t511 ) + rtP . Il_31 *
t15 * t506 * t513 ) + rtP . Il_22 * rtB . hkbmt1bwgv [ 11 ] * t2 * t3 *
ehrq52oenb [ 2 ] * 2.0 ) + rtP . Il_21 * rtB . hkbmt1bwgv [ 11 ] * t506 *
t510 * ehrq52oenb [ 2 ] * 2.0 ) - rtP . Il_21 * rtB . hkbmt1bwgv [ 11 ] *
t508 * t510 * ehrq52oenb [ 2 ] * 2.0 ) + rtP . Il_32 * rtB . hkbmt1bwgv [ 11
] * t506 * t512 * ehrq52oenb [ 2 ] * 2.0 ) - rtP . Il_32 * rtB . hkbmt1bwgv [
11 ] * t508 * t512 * ehrq52oenb [ 2 ] * 2.0 ) + rtP . Il_21 * t2 * t3 * t15 *
t512 ) - rtP . Il_32 * t2 * t3 * t4 * t513 * 4.0 ) - rtP . Il_32 * t2 * t3 *
t15 * t510 ) + rtP . Il_11 * t3 * t4 * t511 * t512 ) - rtP . Il_21 * t2 * t4
* t510 * t512 ) - rtP . Il_21 * t2 * t4 * t511 * t512 * 2.0 ) + rtP . Il_21 *
t2 * t4 * t512 * t513 ) - rtP . Il_31 * t3 * t4 * t510 * t511 ) + rtP . Il_32
* t2 * t4 * t510 * t511 ) + rtP . Il_31 * t3 * t4 * t510 * t513 ) - rtP .
Il_32 * t2 * t4 * t510 * t513 * 2.0 ) + rtP . Il_31 * t3 * t4 * t511 * t513 *
6.0 ) - rtP . Il_33 * t3 * t4 * t511 * t512 ) - rtP . Il_11 * t4 * t506 *
t511 * t512 ) + rtP . Il_11 * t4 * t508 * t511 * t512 ) + rtP . Il_11 * t4 *
t510 * t511 * t512 ) - rtP . Il_11 * t4 * t510 * t512 * t513 ) + rtP . Il_11
* t15 * t506 * t510 * t512 ) + rtP . Il_22 * t4 * t506 * t510 * t512 ) - rtP
. Il_31 * t4 * t506 * t510 * t513 * 2.0 ) + rtP . Il_31 * t4 * t508 * t510 *
t513 * 2.0 ) + rtP . Il_31 * t4 * t508 * t511 * t513 * 3.0 ) - rtP . Il_33 *
t4 * t506 * t512 * t513 ) + rtP . Il_33 * t4 * t508 * t512 * t513 ) - rtP .
Il_33 * t4 * t510 * t511 * t512 * 2.0 ) - rtP . Il_33 * t15 * t506 * t510 *
t512 ) - rtP . Il_11 * rtB . hkbmt1bwgv [ 11 ] * t2 * t3 * t511 * ehrq52oenb
[ 2 ] * 2.0 ) - rtP . Il_33 * rtB . hkbmt1bwgv [ 11 ] * t2 * t3 * t513 *
ehrq52oenb [ 2 ] * 2.0 ) - rtP . Il_21 * t2 * t3 * t4 * t510 * t512 * 4.0 ) -
rtP . Il_21 * t2 * t3 * t4 * t511 * t512 * 2.0 ) + rtP . Il_21 * t2 * t3 * t4
* t512 * t513 ) - rtP . Il_32 * t2 * t3 * t4 * t510 * t513 * 3.0 ) + rtP .
Il_11 * t3 * t4 * t510 * t511 * t512 * 2.0 ) - rtP . Il_11 * t3 * t4 * t510 *
t512 * t513 * 2.0 ) - rtP . Il_33 * t3 * t4 * t510 * t511 * t512 * 2.0 ) +
rtP . Il_33 * t3 * t4 * t510 * t512 * t513 * 2.0 ) + rtP . Il_11 * t4 * t508
* t510 * t511 * t512 ) - rtP . Il_11 * t4 * t508 * t510 * t512 * t513 ) + rtP
. Il_33 * t4 * t508 * t510 * t512 * t513 * 2.0 ) - rtP . Il_31 * rtB .
hkbmt1bwgv [ 11 ] * t2 * t3 * t510 * t512 * ehrq52oenb [ 2 ] * 4.0 ; t2 =
muDoubleScalarTan ( rtB . hkbmt1bwgv [ 3 ] ) ; t3 = 1.0 / rtP . L ; t5 = t2 *
rtP . w + rtP . L ; t8 = muDoubleScalarTan ( 1.0 / t5 * t2 ) ; t9 = rtB .
hkbmt1bwgv [ 3 ] + rtB . hkbmt1bwgv [ 2 ] ; t10 = muDoubleScalarCos ( t9 ) ;
t11 = muDoubleScalarSin ( t9 ) ; t13 = muDoubleScalarCos ( rtB . hkbmt1bwgv [
3 ] ) ; t14 = muDoubleScalarSin ( rtB . hkbmt1bwgv [ 3 ] ) ; t15 = t14 * rtP
. w * 0.5 ; t16 = 0.0 * t10 * 0.0 ; t17 = 0.0 * t11 * 0.0 ; t18 = ( t15 - rtP
. L * t13 ) * 0.0 ; t21 = muDoubleScalarAtan ( rtP . L * t8 ) + rtB .
hkbmt1bwgv [ 2 ] ; t22 = rtB . hkbmt1bwgv [ 4 ] + rtB . hkbmt1bwgv [ 2 ] ;
t24 = rtP . L * rtP . L ; t28 = 1.0 / muDoubleScalarSqrt ( t8 * t8 * t24 +
1.0 ) ; t29 = muDoubleScalarSin ( t21 ) ; t31 = 0.0 * muDoubleScalarCos ( t22
) ; t32 = muDoubleScalarCos ( t21 ) ; t34 = 0.0 * muDoubleScalarSin ( t22 ) ;
t9 = muDoubleScalarSin ( rtB . hkbmt1bwgv [ 4 ] ) * rtP . w * 0.5 + rtP . L *
muDoubleScalarCos ( rtB . hkbmt1bwgv [ 4 ] ) ; g4r1yovtie [ 0 ] = 0.0 ;
g4r1yovtie [ 1 ] = 0.0 ; g4r1yovtie [ 2 ] = t10 + t16 ; g4r1yovtie [ 3 ] = -
t11 + t16 ; g4r1yovtie [ 4 ] = t31 + t32 ; g4r1yovtie [ 5 ] = - t29 + t31 ;
g4r1yovtie [ 6 ] = 0.0 ; g4r1yovtie [ 7 ] = 0.0 ; g4r1yovtie [ 8 ] = t11 +
t17 ; g4r1yovtie [ 9 ] = t10 + t17 ; g4r1yovtie [ 10 ] = t29 + t34 ;
g4r1yovtie [ 11 ] = t32 + t34 ; g4r1yovtie [ 12 ] = 0.0 ; g4r1yovtie [ 13 ] =
0.0 ; g4r1yovtie [ 14 ] = ( t15 + t18 ) - rtP . L * t13 ; g4r1yovtie [ 15 ] =
( rtP . L * t14 + t18 ) + t13 * rtP . w * 0.5 ; g4r1yovtie [ 16 ] = ( - rtP .
L * t28 - 0.0 * t9 ) - rtP . L * t8 * t28 * rtP . w * 0.5 ; g4r1yovtie [ 17 ]
= ( t28 * rtP . w * - 0.5 - 0.0 * t9 ) + t8 * t24 * t28 ; g4r1yovtie [ 18 ] =
( t2 * t2 + 1.0 ) * t3 * ( rtP . L - rtP . L * t8 * rtP . w ) ; g4r1yovtie [
19 ] = 0.0 ; g4r1yovtie [ 20 ] = 0.0 ; g4r1yovtie [ 21 ] = 0.0 ; g4r1yovtie [
22 ] = 0.0 ; g4r1yovtie [ 23 ] = 0.0 ; g4r1yovtie [ 24 ] = ( t8 * t8 * t24 +
1.0 ) * ( - t3 * t5 ) ; g4r1yovtie [ 25 ] = 0.0 ; g4r1yovtie [ 26 ] = 0.0 ;
g4r1yovtie [ 27 ] = 0.0 ; g4r1yovtie [ 28 ] = 0.0 ; g4r1yovtie [ 29 ] = 0.0 ;
g4r1yovtie [ 30 ] = 0.0 ; g4r1yovtie [ 31 ] = 0.0 ; g4r1yovtie [ 32 ] = - rtP
. R ; g4r1yovtie [ 33 ] = 0.0 ; g4r1yovtie [ 34 ] = 0.0 ; g4r1yovtie [ 35 ] =
0.0 ; g4r1yovtie [ 36 ] = 0.0 ; g4r1yovtie [ 37 ] = 0.0 ; g4r1yovtie [ 38 ] =
0.0 ; g4r1yovtie [ 39 ] = 0.0 ; g4r1yovtie [ 40 ] = - rtP . R ; g4r1yovtie [
41 ] = 0.0 ; g4r1yovtie [ 42 ] = 0.0 ; g4r1yovtie [ 43 ] = - t2 * t3 * rtP .
w - 1.0 ; g4r1yovtie [ 44 ] = 0.0 ; g4r1yovtie [ 45 ] = 0.0 ; g4r1yovtie [ 46
] = 0.0 ; g4r1yovtie [ 47 ] = 0.0 ; g4r1yovtie [ 48 ] = 0.0 ; g4r1yovtie [ 49
] = 1.0 ; g4r1yovtie [ 50 ] = 0.0 ; g4r1yovtie [ 51 ] = 0.0 ; g4r1yovtie [ 52
] = 0.0 ; g4r1yovtie [ 53 ] = 0.0 ; t2 = rtP . L * rtP . L ; t3 =
muDoubleScalarTan ( rtB . hkbmt1bwgv [ 3 ] ) ; t4 = t3 * t3 ; t7 = t3 * rtP .
w + rtP . L ; t8 = 1.0 / ( t7 * t7 ) ; t10 = rtP . w * rtP . w ; t13 = ( ( t2
* t4 + t2 ) + t4 * t10 ) + rtP . L * t3 * rtP . w * 2.0 ; t14 = t8 * t13 ;
t15 = muDoubleScalarSqrt ( t14 ) ; t16 = rtB . hkbmt1bwgv [ 3 ] + rtB .
hkbmt1bwgv [ 2 ] ; t17 = muDoubleScalarCos ( t16 ) ; t18 = rtB . hkbmt1bwgv [
4 ] + rtB . hkbmt1bwgv [ 2 ] ; t19 = muDoubleScalarCos ( t18 ) ; t20 =
muDoubleScalarCos ( rtB . hkbmt1bwgv [ 4 ] ) ; t21 = muDoubleScalarCos ( rtB
. hkbmt1bwgv [ 3 ] ) ; t22 = muDoubleScalarSin ( rtB . hkbmt1bwgv [ 4 ] ) ;
t23 = muDoubleScalarSin ( rtB . hkbmt1bwgv [ 3 ] ) ; t25 = muDoubleScalarSin
( t16 ) ; t26 = 1.0 / t7 ; t29 = muDoubleScalarAtan ( rtP . L * t3 * t26 ) +
rtB . hkbmt1bwgv [ 2 ] ; t30 = muDoubleScalarCos ( t29 ) ; t31 =
muDoubleScalarSin ( t29 ) ; t32 = t30 * t30 ; t33 = t31 * t31 ; t34 =
muDoubleScalarSin ( t18 ) ; t35 = 0.0 * t2 * 0.0 * t15 * t19 * t23 * t30 *
2.0 ; t36 = 0.0 * t2 * 0.0 * t15 * t23 * t30 * t34 * 2.0 ; t37 = 0.0 * t2 *
0.0 * t15 * t23 * t31 * t34 * 2.0 ; t38 = 0.0 * t3 * 0.0 * t10 * t15 * t19 *
t21 * t30 ; t9 = 0.0 * t3 * 0.0 * t10 * t15 * t21 * t30 * t34 ; t40 = rtP . L
* 0.0 * 0.0 * t15 * t19 * t21 * t30 * rtP . w ; t41 = 0.0 * t3 * 0.0 * t10 *
t15 * t21 * t31 * t34 ; t42 = rtP . L * 0.0 * 0.0 * t15 * t21 * t30 * t34 *
rtP . w ; t43 = rtP . L * 0.0 * 0.0 * t15 * t21 * t31 * t34 * rtP . w ; t11 =
0.0 * t2 * 0.0 * t15 * t19 * t21 * 0.0 * t31 * 2.0 ; t45 = rtP . L * 0.0 * t3
* 0.0 * t15 * t19 * t23 * t30 * rtP . w * 2.0 ; t46 = rtP . L * 0.0 * t3 *
0.0 * t15 * t23 * t30 * t34 * rtP . w * 2.0 ; t47 = rtP . L * 0.0 * t3 * 0.0
* t15 * t23 * t31 * t34 * rtP . w * 2.0 ; t48 = 0.0 * t3 * 0.0 * t10 * t15 *
t19 * t23 * 0.0 * t30 ; t49 = 0.0 * t3 * 0.0 * t10 * t15 * t23 * 0.0 * t30 *
t34 ; t50 = rtP . L * 0.0 * 0.0 * 0.0 * t15 * t19 * t23 * 0.0 * t30 * rtP . w
; t51 = 0.0 * t3 * 0.0 * t10 * t15 * t23 * 0.0 * t31 * t34 ; t52 = rtP . L *
0.0 * 0.0 * 0.0 * t15 * t23 * 0.0 * t30 * t34 * rtP . w ; t53 = rtP . L * 0.0
* 0.0 * 0.0 * t15 * t23 * 0.0 * t31 * t34 * rtP . w ; t54 = rtP . L * 0.0 *
0.0 * t3 * 0.0 * t15 * t19 * t21 * 0.0 * t31 * rtP . w * 2.0 ; t55 = t2 * t17
* t31 * 2.0 ; t56 = t2 * t15 * t23 * t32 * 2.0 ; t57 = t2 * t15 * t23 * t33 *
2.0 ; t58 = t3 * t10 * t17 * t30 ; t59 = rtP . L * t17 * t30 * rtP . w ; t60
= t3 * t10 * t25 * t31 ; t61 = rtP . L * t25 * t31 * rtP . w ; t62 = t3 * t10
* t15 * t21 * t32 ; t63 = t3 * t10 * t15 * t21 * t33 ; t64 = rtP . L * t15 *
t21 * t32 * rtP . w ; t65 = rtP . L * t15 * t21 * t33 * rtP . w ; t66 = rtP .
L * t3 * t17 * t31 * rtP . w * 3.0 ; t67 = 0.0 * t2 * t17 * 0.0 * t30 * 2.0 ;
t68 = 0.0 * t2 * 0.0 * t25 * t31 * 2.0 ; t69 = rtP . L * t3 * t15 * t23 * t32
* rtP . w * 2.0 ; t70 = rtP . L * t3 * t15 * t23 * t33 * rtP . w * 2.0 ; t71
= 0.0 * t3 * 0.0 * t10 * t17 * t19 ; t72 = rtP . L * 0.0 * 0.0 * t17 * t19 *
rtP . w ; t73 = 0.0 * t3 * 0.0 * t10 * t25 * t34 ; t74 = 0.0 * t2 * t3 * t17
* 0.0 * t31 * 2.0 ; t75 = rtP . L * 0.0 * 0.0 * t25 * t34 * rtP . w ; t76 =
0.0 * t3 * t10 * 0.0 * t25 * t30 ; t77 = rtP . L * 0.0 * 0.0 * t25 * t30 *
rtP . w ; t78 = 0.0 * t3 * t10 * t15 * t23 * 0.0 * t32 ; t79 = 0.0 * t3 * t10
* t15 * t23 * 0.0 * t33 ; t80 = rtP . L * 0.0 * t15 * t23 * 0.0 * t32 * rtP .
w ; t81 = rtP . L * 0.0 * t3 * t17 * 0.0 * t30 * rtP . w * 3.0 ; t82 = rtP .
L * 0.0 * t15 * t23 * 0.0 * t33 * rtP . w ; t83 = 0.0 * t2 * 0.0 * t15 * t17
* t20 * t30 * 2.0 ; t84 = 0.0 * t2 * 0.0 * t15 * t17 * t20 * t31 * 2.0 ; t85
= rtP . L * 0.0 * t3 * 0.0 * t25 * t31 * rtP . w * 3.0 ; t86 = 0.0 * t2 * 0.0
* t17 * 0.0 * t34 * 2.0 ; t87 = 0.0 * t2 * 0.0 * t15 * t19 * t23 * t31 * 2.0
; t88 = 0.0 * t2 * 0.0 * t15 * t20 * t25 * t31 * 2.0 ; t89 = 0.0 * t2 * t3 *
0.0 * t17 * 0.0 * t34 * 2.0 ; t90 = 0.0 * t3 * 0.0 * t10 * t15 * t17 * t22 *
t30 ; t91 = 0.0 * t3 * 0.0 * t10 * t15 * t19 * t21 * t31 ; t92 = 0.0 * t3 *
0.0 * t10 * t19 * 0.0 * t25 ; t93 = 0.0 * t3 * 0.0 * t10 * t15 * t17 * t22 *
t31 ; t94 = rtP . L * 0.0 * 0.0 * t15 * t17 * t22 * t30 * rtP . w ; t95 = rtP
. L * 0.0 * 0.0 * t15 * t19 * t21 * t31 * rtP . w ; t96 = 0.0 * t3 * 0.0 *
t10 * t15 * t22 * t25 * t31 ; t97 = rtP . L * 0.0 * 0.0 * 0.0 * t19 * 0.0 *
t25 * rtP . w ; t98 = rtP . L * 0.0 * 0.0 * t15 * t17 * t22 * t31 * rtP . w ;
t99 = rtP . L * 0.0 * 0.0 * t15 * t22 * t25 * t31 * rtP . w ; t100 = 0.0 * t2
* 0.0 * t15 * t20 * 0.0 * t25 * t30 * 2.0 ; t101 = 0.0 * t2 * 0.0 * t15 * t21
* 0.0 * t30 * t34 * 2.0 ; t102 = 0.0 * t2 * 0.0 * t15 * t20 * 0.0 * t25 * t31
* 2.0 ; t103 = rtP . L * 0.0 * t3 * 0.0 * t15 * t17 * t20 * t30 * rtP . w *
2.0 ; t104 = rtP . L * 0.0 * t3 * 0.0 * t15 * t17 * t20 * t31 * rtP . w * 2.0
; t105 = rtP . L * 0.0 * 0.0 * t3 * 0.0 * t17 * 0.0 * t34 * rtP . w * 3.0 ;
t106 = rtP . L * 0.0 * t3 * 0.0 * t15 * t19 * t23 * t31 * rtP . w * 2.0 ;
t107 = rtP . L * 0.0 * t3 * 0.0 * t15 * t20 * t25 * t31 * rtP . w * 2.0 ;
t108 = 0.0 * t2 * 0.0 * t15 * t17 * t20 * 0.0 * t30 * 2.0 ; t109 = 0.0 * t3 *
0.0 * t10 * t15 * t17 * t22 * 0.0 * t30 ; t110 = 0.0 * t3 * 0.0 * t10 * t15 *
t19 * t23 * 0.0 * t31 ; t111 = 0.0 * t3 * 0.0 * t10 * t15 * t22 * 0.0 * t25 *
t30 ; t112 = rtP . L * 0.0 * 0.0 * 0.0 * t15 * t17 * t22 * 0.0 * t30 * rtP .
w ; t113 = 0.0 * t3 * 0.0 * t10 * t15 * t22 * 0.0 * t25 * t31 ; t114 = rtP .
L * 0.0 * 0.0 * 0.0 * t15 * t19 * t23 * 0.0 * t31 * rtP . w ; t115 = rtP . L
* 0.0 * 0.0 * 0.0 * t15 * t22 * 0.0 * t25 * t30 * rtP . w ; t116 = rtP . L *
0.0 * 0.0 * 0.0 * t15 * t22 * 0.0 * t25 * t31 * rtP . w ; t117 = rtP . L *
0.0 * 0.0 * t3 * 0.0 * t15 * t20 * 0.0 * t25 * t31 * rtP . w * 2.0 ; t118 =
rtP . L * 0.0 * 0.0 * t3 * 0.0 * t15 * t17 * t20 * 0.0 * t30 * rtP . w * 2.0
; t16 = rtP . L * 0.0 * 0.0 * t3 * 0.0 * t15 * t20 * 0.0 * t25 * t30 * rtP .
w * 2.0 ; t120 = rtP . L * 0.0 * 0.0 * t3 * 0.0 * t15 * t21 * 0.0 * t30 * t34
* rtP . w * 2.0 ; t164 = 0.0 * t2 * 0.0 * t15 * t20 * t25 * t30 * 2.0 ; t170
= 0.0 * t3 * 0.0 * t10 * t15 * t22 * t25 * t30 ; t172 = rtP . L * 0.0 * 0.0 *
t15 * t22 * t25 * t30 * rtP . w ; t173 = 0.0 * t2 * 0.0 * t15 * t17 * t20 *
0.0 * t31 * 2.0 ; t174 = 0.0 * t2 * 0.0 * t15 * t21 * 0.0 * t31 * t34 * 2.0 ;
t175 = rtP . L * 0.0 * t3 * 0.0 * t15 * t20 * t25 * t30 * rtP . w * 2.0 ;
t177 = 0.0 * t2 * 0.0 * t15 * t19 * t21 * 0.0 * t30 * 2.0 ; t178 = 0.0 * t3 *
0.0 * t10 * t15 * t17 * t22 * 0.0 * t31 ; t179 = rtP . L * 0.0 * 0.0 * 0.0 *
t15 * t17 * t22 * 0.0 * t31 * rtP . w ; t180 = rtP . L * 0.0 * 0.0 * t3 * 0.0
* t15 * t21 * 0.0 * t31 * t34 * rtP . w * 2.0 ; t181 = rtP . L * 0.0 * 0.0 *
t3 * 0.0 * t15 * t19 * t21 * 0.0 * t30 * rtP . w * 2.0 ; t182 = rtP . L * 0.0
* 0.0 * t3 * 0.0 * t15 * t17 * t20 * 0.0 * t31 * rtP . w * 2.0 ; t123 = ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( t35
+ t36 ) + t37 ) + t38 ) + t9 ) + t40 ) + t41 ) + t42 ) + t43 ) + t11 ) + t45
) + t46 ) + t47 ) + t48 ) + t49 ) + t50 ) + t51 ) + t52 ) + t53 ) + t54 ) +
t55 ) + t56 ) + t57 ) + t58 ) + t59 ) + t60 ) + t61 ) + t62 ) + t63 ) + t64 )
+ t65 ) + t66 ) + t67 ) + t68 ) + t69 ) + t70 ) + t71 ) + t72 ) + t73 ) + t74
) + t75 ) + t76 ) + t77 ) + t78 ) + t79 ) + t80 ) + t81 ) + t82 ) + t83 ) +
t84 ) + t85 ) + t86 ) - t87 ) + t88 ) + t89 ) + t90 ) - t91 ) + t92 ) + t93 )
+ t94 ) - t95 ) + t96 ) + t97 ) + t98 ) + t99 ) + t100 ) - t101 ) + t102 ) +
t103 ) + t104 ) + t105 ) - t106 ) + t107 ) + t108 ) + t109 ) - t110 ) + t111
) + t112 ) + t113 ) - t114 ) + t115 ) + t116 ) + t117 ) + t118 ) + t16 ) -
t120 ) - t2 * t25 * t30 * 2.0 ) - t2 * t3 * t17 * t30 * 2.0 ) - t2 * t3 * t25
* t31 * 2.0 ) - rtP . L * t3 * t25 * t30 * rtP . w * 3.0 ) - 0.0 * t2 * 0.0 *
t17 * t19 * 2.0 ) - 0.0 * t2 * 0.0 * t25 * t34 * 2.0 ) - 0.0 * t2 * t3 * 0.0
* t17 * t19 * 2.0 ) - 0.0 * t2 * t15 * t21 * 0.0 * t32 * 2.0 ) - 0.0 * t2 *
t3 * 0.0 * t25 * t34 * 2.0 ) - 0.0 * t2 * t15 * t21 * 0.0 * t33 * 2.0 ) - 0.0
* t2 * t3 * 0.0 * t25 * t30 * 2.0 ) - 0.0 * t3 * t10 * t17 * 0.0 * t31 ) -
rtP . L * 0.0 * t17 * 0.0 * t31 * rtP . w ) - rtP . L * 0.0 * t3 * 0.0 * t17
* t19 * rtP . w * 3.0 ) - rtP . L * 0.0 * t3 * 0.0 * t25 * t34 * rtP . w *
3.0 ) - t164 ) - 0.0 * t2 * 0.0 * t19 * 0.0 * t25 * 2.0 ) - rtP . L * 0.0 *
t3 * t15 * t21 * 0.0 * t32 * rtP . w * 2.0 ) - rtP . L * 0.0 * t3 * t15 * t21
* 0.0 * t33 * rtP . w * 2.0 ) - 0.0 * t2 * t3 * 0.0 * t19 * 0.0 * t25 * 2.0 )
- 0.0 * t3 * 0.0 * t10 * t17 * 0.0 * t34 ) - t170 ) - rtP . L * 0.0 * 0.0 *
0.0 * t17 * 0.0 * t34 * rtP . w ) - t172 ) - t173 ) - t174 ) - t175 ) - rtP .
L * 0.0 * 0.0 * t3 * 0.0 * t19 * 0.0 * t25 * rtP . w * 3.0 ) - t177 ) - t178
) - t179 ) - t180 ) - t181 ) - t182 ; t124 = rtP . L * rtP . R * t17 * rtP .
w ; t125 = rtP . R * t3 * t10 * t17 ; t129 = rtP . R * 0.0 * t3 * t10 * 0.0 *
t25 ; t130 = rtP . L * rtP . R * 0.0 * 0.0 * t25 * rtP . w ; t132 = rtP . R *
0.0 * t2 * 0.0 * t15 * t17 * t20 * 2.0 ; t133 = rtP . R * 0.0 * t2 * 0.0 *
t15 * t23 * t34 * 2.0 ; t134 = rtP . R * 0.0 * t3 * 0.0 * t10 * t15 * t17 *
t22 ; t135 = rtP . R * 0.0 * t3 * 0.0 * t10 * t15 * t21 * t34 ; t136 = rtP .
L * rtP . R * 0.0 * 0.0 * t15 * t17 * t22 * rtP . w ; t137 = rtP . L * rtP .
R * 0.0 * 0.0 * t15 * t21 * t34 * rtP . w ; t140 = rtP . L * rtP . R * 0.0 *
t3 * 0.0 * t15 * t17 * t20 * rtP . w * 2.0 ; t141 = rtP . L * rtP . R * 0.0 *
t3 * 0.0 * t15 * t23 * t34 * rtP . w * 2.0 ; t142 = rtP . R * 0.0 * 0.0 * t2
* 0.0 * t15 * t20 * 0.0 * t25 * 2.0 ; t143 = rtP . R * 0.0 * 0.0 * t3 * 0.0 *
t10 * t15 * t22 * 0.0 * t25 ; t144 = rtP . R * 0.0 * 0.0 * t3 * 0.0 * t10 *
t15 * t23 * 0.0 * t34 ; t145 = rtP . L * rtP . R * 0.0 * 0.0 * 0.0 * t15 *
t22 * 0.0 * t25 * rtP . w ; t146 = rtP . L * rtP . R * 0.0 * 0.0 * 0.0 * t15
* t23 * 0.0 * t34 * rtP . w ; t147 = rtP . L * rtP . R * 0.0 * 0.0 * t3 * 0.0
* t15 * t20 * 0.0 * t25 * rtP . w * 2.0 ; t185 = rtP . R * t2 * t3 * t17 *
2.0 ; t186 = rtP . R * 0.0 * t2 * t3 * 0.0 * t25 * 2.0 ; t127 = rtP . R * 0.0
* 0.0 * t2 * 0.0 * t15 * t21 * 0.0 * t34 * 2.0 ; t131 = rtP . L * rtP . R *
0.0 * 0.0 * t3 * 0.0 * t15 * t21 * 0.0 * t34 * rtP . w * 2.0 ; t148 = ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( rtP . R * t2 * t15 * t23 * t30
* 2.0 + ( t124 + t125 ) ) + rtP . R * t3 * t10 * t15 * t21 * t30 ) + rtP . L
* rtP . R * t15 * t21 * t30 * rtP . w ) + t129 ) + t130 ) + rtP . L * rtP . R
* t3 * t15 * t23 * t30 * rtP . w * 2.0 ) + t132 ) + t133 ) + t134 ) + t135 )
+ t136 ) + t137 ) + rtP . R * 0.0 * t3 * t10 * t15 * t23 * 0.0 * t30 ) + rtP
. L * rtP . R * 0.0 * t15 * t23 * 0.0 * t30 * rtP . w ) + t140 ) + t141 ) +
t142 ) + t143 ) + t144 ) + t145 ) + t146 ) + t147 ) - t185 ) - t186 ) - rtP .
R * 0.0 * t2 * t15 * t21 * 0.0 * t30 * 2.0 ) - rtP . L * rtP . R * 0.0 * t3 *
t15 * t21 * 0.0 * t30 * rtP . w * 2.0 ) - t127 ) - t131 ; t139 = 1.0 / ( t123
* t123 ) ; t123 = 1.0 / t123 ; t195 = ( t2 * t3 * ( t4 + 1.0 ) * 2.0 + t3 *
t10 * ( t4 + 1.0 ) * 2.0 ) + ( t4 + 1.0 ) * rtP . L * rtP . w * 2.0 ; t149 =
t8 * t195 - ( t4 + 1.0 ) * t13 * ( 1.0 / muDoubleScalarPower ( t7 , 3.0 ) ) *
rtP . w * 2.0 ; t199 = 1.0 / muDoubleScalarSqrt ( t14 ) ; t153 = 1.0 / ( t2 *
t4 * t8 + 1.0 ) ; t151 = rtP . L * t26 * ( t4 + 1.0 ) - rtP . L * t3 * t8 * (
t4 + 1.0 ) * rtP . w ; t159 = 0.0 * t2 * 0.0 * t17 * t34 * 2.0 ; t156 = 0.0 *
t2 * t3 * 0.0 * t17 * t34 * 2.0 ; t155 = 0.0 * t3 * 0.0 * t10 * t19 * t25 ;
t210 = rtP . L * 0.0 * 0.0 * t19 * t25 * rtP . w ; t211 = rtP . L * 0.0 * t3
* 0.0 * t17 * t34 * rtP . w * 3.0 ; t212 = 0.0 * t2 * 0.0 * t17 * t19 * 0.0 *
2.0 ; t213 = 0.0 * t2 * 0.0 * 0.0 * t25 * t34 * 2.0 ; t214 = 0.0 * t2 * t3 *
0.0 * t17 * t19 * 0.0 * 2.0 ; t215 = 0.0 * t2 * t3 * 0.0 * 0.0 * t25 * t34 *
2.0 ; t216 = rtP . L * 0.0 * 0.0 * t3 * 0.0 * t17 * t19 * 0.0 * rtP . w * 3.0
; t217 = rtP . L * 0.0 * 0.0 * t3 * 0.0 * 0.0 * t25 * t34 * rtP . w * 3.0 ;
t220 = rtP . R * t2 * t3 * t25 * 2.0 ; t221 = rtP . R * 0.0 * t3 * t10 * t17
* 0.0 ; t222 = rtP . L * rtP . R * 0.0 * t17 * 0.0 * rtP . w ; t223 = rtP . R
* 0.0 * t2 * 0.0 * t15 * t19 * t23 * 2.0 ; t224 = rtP . R * 0.0 * t3 * 0.0 *
t10 * t15 * t19 * t21 ; t225 = rtP . L * rtP . R * 0.0 * 0.0 * t15 * t19 *
t21 * rtP . w ; t226 = rtP . L * rtP . R * 0.0 * t3 * 0.0 * t15 * t19 * t23 *
rtP . w * 2.0 ; t227 = rtP . R * 0.0 * 0.0 * t2 * 0.0 * t15 * t17 * t20 * 0.0
* 2.0 ; t228 = rtP . R * 0.0 * 0.0 * t3 * 0.0 * t10 * t15 * t17 * t22 * 0.0 ;
t160 = rtP . R * 0.0 * 0.0 * t3 * 0.0 * t10 * t15 * t19 * t23 * 0.0 ; t230 =
rtP . L * rtP . R * 0.0 * 0.0 * 0.0 * t15 * t17 * t22 * 0.0 * rtP . w ; t231
= rtP . L * rtP . R * 0.0 * 0.0 * 0.0 * t15 * t19 * t23 * 0.0 * rtP . w ;
t232 = rtP . L * rtP . R * 0.0 * 0.0 * t3 * 0.0 * t15 * t17 * t20 * 0.0 * rtP
. w * 2.0 ; t233 = rtP . R * 0.0 * t2 * t15 * t21 * 0.0 * t31 * 2.0 ; t234 =
rtP . L * rtP . R * 0.0 * t3 * t15 * t21 * 0.0 * t31 * rtP . w * 2.0 ; t14 =
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( t3 * 0.0 * t10 * t17 * t19 + rtP . L * 0.0 * t17 * t19 * rtP . w ) +
t3 * 0.0 * t10 * t25 * t34 ) + rtP . L * 0.0 * t25 * t34 * rtP . w ) + t2 *
0.0 * t15 * t17 * t20 * t30 * 2.0 ) + t2 * 0.0 * t15 * t17 * t20 * t31 * 2.0
) + t2 * 0.0 * t15 * t19 * t23 * t30 * 2.0 ) + 0.0 * t2 * 0.0 * t17 * 0.0 *
t34 * 2.0 ) + t2 * 0.0 * t15 * t20 * t25 * t31 * 2.0 ) + t2 * 0.0 * t15 * t23
* t30 * t34 * 2.0 ) + t2 * 0.0 * t15 * t23 * t31 * t34 * 2.0 ) + 0.0 * t2 *
t3 * 0.0 * t17 * 0.0 * t34 * 2.0 ) + t3 * 0.0 * t10 * t15 * t19 * t21 * t30 )
+ t3 * 0.0 * t10 * t15 * t17 * t22 * t30 ) + t3 * 0.0 * t10 * t15 * t21 * t30
* t34 ) + rtP . L * 0.0 * t15 * t19 * t21 * t30 * rtP . w ) + 0.0 * t3 * 0.0
* t10 * t19 * 0.0 * t25 ) + t3 * 0.0 * t10 * t15 * t17 * t22 * t31 ) + t3 *
0.0 * t10 * t15 * t21 * t31 * t34 ) + rtP . L * 0.0 * t15 * t17 * t22 * t30 *
rtP . w ) + rtP . L * 0.0 * t15 * t21 * t30 * t34 * rtP . w ) + t3 * 0.0 *
t10 * t15 * t22 * t25 * t31 ) + rtP . L * 0.0 * 0.0 * t19 * 0.0 * t25 * rtP .
w ) + rtP . L * 0.0 * t15 * t17 * t22 * t31 * rtP . w ) + rtP . L * 0.0 * t15
* t21 * t31 * t34 * rtP . w ) + rtP . L * 0.0 * t15 * t22 * t25 * t31 * rtP .
w ) + rtP . L * t3 * 0.0 * t15 * t17 * t20 * t30 * rtP . w * 2.0 ) + rtP . L
* t3 * 0.0 * t15 * t17 * t20 * t31 * rtP . w * 2.0 ) + rtP . L * t3 * 0.0 *
t15 * t19 * t23 * t30 * rtP . w * 2.0 ) + rtP . L * 0.0 * t3 * 0.0 * t17 *
0.0 * t34 * rtP . w * 3.0 ) + rtP . L * t3 * 0.0 * t15 * t20 * t25 * t31 *
rtP . w * 2.0 ) + rtP . L * t3 * 0.0 * t15 * t23 * t30 * t34 * rtP . w * 2.0
) + rtP . L * t3 * 0.0 * t15 * t23 * t31 * t34 * rtP . w * 2.0 ) + 0.0 * t2 *
0.0 * t15 * t17 * t20 * 0.0 * t30 * 2.0 ) + 0.0 * t2 * 0.0 * t15 * t19 * t21
* 0.0 * t31 * 2.0 ) + 0.0 * t2 * 0.0 * t15 * t20 * 0.0 * t25 * t30 * 2.0 ) +
0.0 * t2 * 0.0 * t15 * t20 * 0.0 * t25 * t31 * 2.0 ) + 0.0 * t3 * 0.0 * t10 *
t15 * t17 * t22 * 0.0 * t30 ) + 0.0 * t3 * 0.0 * t10 * t15 * t19 * t23 * 0.0
* t30 ) + 0.0 * t3 * 0.0 * t10 * t15 * t22 * 0.0 * t25 * t30 ) + 0.0 * t3 *
0.0 * t10 * t15 * t23 * 0.0 * t30 * t34 ) + rtP . L * 0.0 * 0.0 * t15 * t17 *
t22 * 0.0 * t30 * rtP . w ) + rtP . L * 0.0 * 0.0 * t15 * t19 * t23 * 0.0 *
t30 * rtP . w ) + 0.0 * t3 * 0.0 * t10 * t15 * t22 * 0.0 * t25 * t31 ) + 0.0
* t3 * 0.0 * t10 * t15 * t23 * 0.0 * t31 * t34 ) + rtP . L * 0.0 * 0.0 * t15
* t22 * 0.0 * t25 * t30 * rtP . w ) + rtP . L * 0.0 * 0.0 * t15 * t23 * 0.0 *
t30 * t34 * rtP . w ) + rtP . L * 0.0 * 0.0 * t15 * t22 * 0.0 * t25 * t31 *
rtP . w ) + rtP . L * 0.0 * 0.0 * t15 * t23 * 0.0 * t31 * t34 * rtP . w ) +
rtP . L * 0.0 * t3 * 0.0 * t15 * t17 * t20 * 0.0 * t30 * rtP . w * 2.0 ) +
rtP . L * 0.0 * t3 * 0.0 * t15 * t19 * t21 * 0.0 * t31 * rtP . w * 2.0 ) +
rtP . L * 0.0 * t3 * 0.0 * t15 * t20 * 0.0 * t25 * t30 * rtP . w * 2.0 ) +
rtP . L * 0.0 * t3 * 0.0 * t15 * t20 * 0.0 * t25 * t31 * rtP . w * 2.0 ) - t2
* 0.0 * t17 * t19 * 2.0 ) - t2 * 0.0 * t25 * t34 * 2.0 ) - t2 * t3 * 0.0 *
t25 * t34 * 2.0 ) - t2 * t3 * 0.0 * t17 * t19 * 2.0 ) - rtP . L * t3 * 0.0 *
t17 * t19 * rtP . w * 3.0 ) - rtP . L * t3 * 0.0 * t25 * t34 * rtP . w * 3.0
) - t2 * 0.0 * t15 * t20 * t25 * t30 * 2.0 ) - 0.0 * t2 * 0.0 * t19 * 0.0 *
t25 * 2.0 ) - t2 * 0.0 * t15 * t19 * t23 * t31 * 2.0 ) - 0.0 * t2 * t3 * 0.0
* t19 * 0.0 * t25 * 2.0 ) - t3 * 0.0 * t10 * t15 * t19 * t21 * t31 ) - 0.0 *
t3 * 0.0 * t10 * t17 * 0.0 * t34 ) - t3 * 0.0 * t10 * t15 * t22 * t25 * t30 )
- rtP . L * 0.0 * t15 * t19 * t21 * t31 * rtP . w ) - rtP . L * 0.0 * 0.0 *
t17 * 0.0 * t34 * rtP . w ) - rtP . L * 0.0 * t15 * t22 * t25 * t30 * rtP . w
) - rtP . L * t3 * 0.0 * t15 * t20 * t25 * t30 * rtP . w * 2.0 ) - rtP . L *
0.0 * t3 * 0.0 * t19 * 0.0 * t25 * rtP . w * 3.0 ) - rtP . L * t3 * 0.0 * t15
* t19 * t23 * t31 * rtP . w * 2.0 ) - 0.0 * t2 * 0.0 * t15 * t19 * t21 * 0.0
* t30 * 2.0 ) - 0.0 * t2 * 0.0 * t15 * t17 * t20 * 0.0 * t31 * 2.0 ) - 0.0 *
t2 * 0.0 * t15 * t21 * 0.0 * t30 * t34 * 2.0 ) - 0.0 * t2 * 0.0 * t15 * t21 *
0.0 * t31 * t34 * 2.0 ) - 0.0 * t3 * 0.0 * t10 * t15 * t17 * t22 * 0.0 * t31
) - 0.0 * t3 * 0.0 * t10 * t15 * t19 * t23 * 0.0 * t31 ) - rtP . L * 0.0 *
0.0 * t15 * t17 * t22 * 0.0 * t31 * rtP . w ) - rtP . L * 0.0 * 0.0 * t15 *
t19 * t23 * 0.0 * t31 * rtP . w ) - rtP . L * 0.0 * t3 * 0.0 * t15 * t19 *
t21 * 0.0 * t30 * rtP . w * 2.0 ) - rtP . L * 0.0 * t3 * 0.0 * t15 * t17 *
t20 * 0.0 * t31 * rtP . w * 2.0 ) - rtP . L * 0.0 * t3 * 0.0 * t15 * t21 *
0.0 * t30 * t34 * rtP . w * 2.0 ) - rtP . L * 0.0 * t3 * 0.0 * t15 * t21 *
0.0 * t31 * t34 * rtP . w * 2.0 ; t290 = rtP . R * t3 * t10 * t25 ; t291 =
rtP . L * rtP . R * t25 * rtP . w ; t292 = rtP . R * t2 * t15 * t23 * t31 *
2.0 ; t293 = rtP . R * 0.0 * t2 * t3 * t17 * 0.0 * 2.0 ; t294 = rtP . R * t3
* t10 * t15 * t21 * t31 ; t295 = rtP . L * rtP . R * t15 * t21 * t31 * rtP .
w ; t296 = rtP . L * rtP . R * t3 * t15 * t23 * t31 * rtP . w * 2.0 ; t297 =
rtP . R * 0.0 * t2 * 0.0 * t15 * t20 * t25 * 2.0 ; t298 = rtP . R * 0.0 * t3
* 0.0 * t10 * t15 * t22 * t25 ; t299 = rtP . L * rtP . R * 0.0 * 0.0 * t15 *
t22 * t25 * rtP . w ; t300 = rtP . R * 0.0 * t3 * t10 * t15 * t23 * 0.0 * t31
; t301 = rtP . L * rtP . R * 0.0 * t15 * t23 * 0.0 * t31 * rtP . w ; t302 =
rtP . L * rtP . R * 0.0 * t3 * 0.0 * t15 * t20 * t25 * rtP . w * 2.0 ; t303 =
rtP . R * 0.0 * 0.0 * t2 * 0.0 * t15 * t19 * t21 * 0.0 * 2.0 ; t304 = rtP . L
* rtP . R * 0.0 * 0.0 * t3 * 0.0 * t15 * t19 * t21 * 0.0 * rtP . w * 2.0 ;
t194 = ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( t220 + t221 )
+ t222 ) + t223 ) + t224 ) + t225 ) + t226 ) + t227 ) + t228 ) + t160 ) +
t230 ) + t231 ) + t232 ) + t233 ) + t234 ) - t290 ) - t291 ) - t292 ) - t293
) - t294 ) - t295 ) - t296 ) - t297 ) - t298 ) - t299 ) - t300 ) - t301 ) -
t302 ) - t303 ) - t304 ; t341 = ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( 0.0 *
t2 * t17 * t30 * 2.0 + 0.0 * t2 * t25 * t31 * 2.0 ) + 0.0 * t2 * t3 * t17 *
t31 * 2.0 ) + 0.0 * t3 * t10 * t25 * t30 ) + rtP . L * 0.0 * t25 * t30 * rtP
. w ) + 0.0 * t3 * t10 * t15 * t23 * t32 ) + 0.0 * t3 * t10 * t15 * t23 * t33
) + rtP . L * 0.0 * t15 * t23 * t32 * rtP . w ) + rtP . L * 0.0 * t3 * t17 *
t30 * rtP . w * 3.0 ) + rtP . L * 0.0 * t15 * t23 * t33 * rtP . w ) + rtP . L
* 0.0 * t3 * t25 * t31 * rtP . w * 3.0 ) + 0.0 * t2 * 0.0 * t17 * t34 * 2.0 )
+ 0.0 * t2 * t3 * 0.0 * t17 * t34 * 2.0 ) + 0.0 * t3 * 0.0 * t10 * t19 * t25
) + rtP . L * 0.0 * 0.0 * 0.0 * t19 * t25 * rtP . w ) + rtP . L * 0.0 * 0.0 *
t3 * 0.0 * t17 * t34 * rtP . w * 3.0 ) + 0.0 * t2 * 0.0 * t15 * t17 * t20 *
t30 * 2.0 ) + 0.0 * t2 * 0.0 * t15 * t19 * t21 * t31 * 2.0 ) + 0.0 * t2 * 0.0
* t15 * t20 * t25 * t30 * 2.0 ) + 0.0 * t2 * 0.0 * t15 * t20 * t25 * t31 *
2.0 ) + 0.0 * t3 * 0.0 * t10 * t15 * t17 * t22 * t30 ) + 0.0 * t3 * 0.0 * t10
* t15 * t19 * t23 * t30 ) + 0.0 * t3 * 0.0 * t10 * t15 * t22 * t25 * t30 ) +
0.0 * t3 * 0.0 * t10 * t15 * t23 * t30 * t34 ) + rtP . L * 0.0 * 0.0 * 0.0 *
t15 * t17 * t22 * t30 * rtP . w ) + rtP . L * 0.0 * 0.0 * 0.0 * t15 * t19 *
t23 * t30 * rtP . w ) + 0.0 * t3 * 0.0 * t10 * t15 * t22 * t25 * t31 ) + 0.0
* t3 * 0.0 * t10 * t15 * t23 * t31 * t34 ) + rtP . L * 0.0 * 0.0 * 0.0 * t15
* t22 * t25 * t30 * rtP . w ) + rtP . L * 0.0 * 0.0 * 0.0 * t15 * t23 * t30 *
t34 * rtP . w ) + rtP . L * 0.0 * 0.0 * 0.0 * t15 * t22 * t25 * t31 * rtP . w
) + rtP . L * 0.0 * 0.0 * 0.0 * t15 * t23 * t31 * t34 * rtP . w ) + rtP . L *
0.0 * 0.0 * t3 * 0.0 * t15 * t17 * t20 * t30 * rtP . w * 2.0 ) + rtP . L *
0.0 * 0.0 * t3 * 0.0 * t15 * t19 * t21 * t31 * rtP . w * 2.0 ) + rtP . L *
0.0 * 0.0 * t3 * 0.0 * t15 * t20 * t25 * t30 * rtP . w * 2.0 ) + rtP . L *
0.0 * 0.0 * t3 * 0.0 * t15 * t20 * t25 * t31 * rtP . w * 2.0 ) - 0.0 * t2 *
t15 * t21 * t32 * 2.0 ) - 0.0 * t2 * t15 * t21 * t33 * 2.0 ) - 0.0 * t2 * t3
* t25 * t30 * 2.0 ) - 0.0 * t3 * t10 * t17 * t31 ) - rtP . L * 0.0 * t17 *
t31 * rtP . w ) - 0.0 * t2 * 0.0 * t19 * t25 * 2.0 ) - rtP . L * 0.0 * t3 *
t15 * t21 * t32 * rtP . w * 2.0 ) - rtP . L * 0.0 * t3 * t15 * t21 * t33 *
rtP . w * 2.0 ) - 0.0 * t2 * t3 * 0.0 * t19 * t25 * 2.0 ) - 0.0 * t3 * 0.0 *
t10 * t17 * t34 ) - rtP . L * 0.0 * 0.0 * 0.0 * t17 * t34 * rtP . w ) - rtP .
L * 0.0 * 0.0 * t3 * 0.0 * t19 * t25 * rtP . w * 3.0 ) - 0.0 * t2 * 0.0 * t15
* t19 * t21 * t30 * 2.0 ) - 0.0 * t2 * 0.0 * t15 * t17 * t20 * t31 * 2.0 ) -
0.0 * t2 * 0.0 * t15 * t21 * t30 * t34 * 2.0 ) - 0.0 * t2 * 0.0 * t15 * t21 *
t31 * t34 * 2.0 ) - 0.0 * t3 * 0.0 * t10 * t15 * t17 * t22 * t31 ) - 0.0 * t3
* 0.0 * t10 * t15 * t19 * t23 * t31 ) - rtP . L * 0.0 * 0.0 * 0.0 * t15 * t17
* t22 * t31 * rtP . w ) - rtP . L * 0.0 * 0.0 * 0.0 * t15 * t19 * t23 * t31 *
rtP . w ) - rtP . L * 0.0 * 0.0 * t3 * 0.0 * t15 * t19 * t21 * t30 * rtP . w
* 2.0 ) - rtP . L * 0.0 * 0.0 * t3 * 0.0 * t15 * t17 * t20 * t31 * rtP . w *
2.0 ) - rtP . L * 0.0 * 0.0 * t3 * 0.0 * t15 * t21 * t30 * t34 * rtP . w *
2.0 ) - rtP . L * 0.0 * 0.0 * t3 * 0.0 * t15 * t21 * t31 * t34 * rtP . w *
2.0 ; t342 = 0.0 * t2 * 0.0 * t19 * t25 * 2.0 ; t343 = 0.0 * t2 * t3 * 0.0 *
t19 * t25 * 2.0 ; t344 = 0.0 * t3 * 0.0 * t10 * t17 * t34 ; t345 = rtP . L *
0.0 * 0.0 * t17 * t34 * rtP . w ; t346 = rtP . L * 0.0 * t3 * 0.0 * t19 * t25
* rtP . w * 3.0 ; t347 = 0.0 * t2 * 0.0 * t15 * t22 * t25 * t30 * 2.0 ; t348
= 0.0 * t3 * 0.0 * t10 * t15 * t17 * t20 * t30 ; t349 = 0.0 * t3 * 0.0 * t10
* t17 * t19 * 0.0 ; t350 = 0.0 * t3 * 0.0 * t10 * t15 * t17 * t20 * t31 ;
t351 = rtP . L * 0.0 * 0.0 * t15 * t17 * t20 * t30 * rtP . w ; t352 = 0.0 *
t3 * 0.0 * t10 * t15 * t20 * t25 * t31 ; t353 = rtP . L * 0.0 * 0.0 * 0.0 *
t17 * t19 * 0.0 * rtP . w ; t354 = rtP . L * 0.0 * 0.0 * t15 * t17 * t20 *
t31 * rtP . w ; t355 = 0.0 * t3 * 0.0 * t10 * 0.0 * t25 * t34 ; t356 = rtP .
L * 0.0 * 0.0 * t15 * t20 * t25 * t31 * rtP . w ; t357 = rtP . L * 0.0 * 0.0
* 0.0 * 0.0 * t25 * t34 * rtP . w ; t358 = 0.0 * t2 * 0.0 * t15 * t17 * t22 *
0.0 * t31 * 2.0 ; t359 = rtP . L * 0.0 * t3 * 0.0 * t15 * t22 * t25 * t30 *
rtP . w * 2.0 ; t360 = 0.0 * t3 * 0.0 * t10 * t15 * t20 * 0.0 * t25 * t30 ;
t361 = rtP . L * 0.0 * 0.0 * 0.0 * t15 * t17 * t20 * 0.0 * t30 * rtP . w ;
t362 = 0.0 * t3 * 0.0 * t10 * t15 * t20 * 0.0 * t25 * t31 ; t363 = rtP . L *
0.0 * 0.0 * 0.0 * t15 * t20 * 0.0 * t25 * t30 * rtP . w ; t364 = rtP . L *
0.0 * 0.0 * 0.0 * t15 * t20 * 0.0 * t25 * t31 * rtP . w ; t365 = 0.0 * t3 *
0.0 * t10 * t15 * t17 * t20 * 0.0 * t30 ; t366 = rtP . L * 0.0 * 0.0 * t3 *
0.0 * t15 * t17 * t22 * 0.0 * t31 * rtP . w * 2.0 ; t200 = ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( 0.0 * t3
* t10 * t17 * t19 + rtP . L * 0.0 * t17 * t19 * rtP . w ) + 0.0 * t3 * t10 *
t25 * t34 ) + rtP . L * 0.0 * t25 * t34 * rtP . w ) + 0.0 * t2 * t15 * t17 *
t20 * t30 * 2.0 ) + 0.0 * t2 * t15 * t17 * t20 * t31 * 2.0 ) + 0.0 * t2 * t15
* t19 * t23 * t30 * 2.0 ) + 0.0 * t2 * t17 * 0.0 * t34 * 2.0 ) + 0.0 * t2 *
t15 * t20 * t25 * t31 * 2.0 ) + 0.0 * t2 * t15 * t23 * t30 * t34 * 2.0 ) +
0.0 * t2 * t15 * t23 * t31 * t34 * 2.0 ) + 0.0 * t2 * t3 * t17 * 0.0 * t34 *
2.0 ) + 0.0 * t3 * t10 * t15 * t19 * t21 * t30 ) + 0.0 * t3 * t10 * t15 * t17
* t22 * t30 ) + 0.0 * t3 * t10 * t15 * t21 * t30 * t34 ) + rtP . L * 0.0 *
t15 * t19 * t21 * t30 * rtP . w ) + 0.0 * t3 * t10 * t19 * 0.0 * t25 ) + 0.0
* t3 * t10 * t15 * t17 * t22 * t31 ) + 0.0 * t3 * t10 * t15 * t21 * t31 * t34
) + rtP . L * 0.0 * t15 * t17 * t22 * t30 * rtP . w ) + rtP . L * 0.0 * t15 *
t21 * t30 * t34 * rtP . w ) + 0.0 * t3 * t10 * t15 * t22 * t25 * t31 ) + rtP
. L * 0.0 * 0.0 * t19 * 0.0 * t25 * rtP . w ) + rtP . L * 0.0 * t15 * t17 *
t22 * t31 * rtP . w ) + rtP . L * 0.0 * t15 * t21 * t31 * t34 * rtP . w ) +
rtP . L * 0.0 * t15 * t22 * t25 * t31 * rtP . w ) + rtP . L * 0.0 * t3 * t15
* t17 * t20 * t30 * rtP . w * 2.0 ) + rtP . L * 0.0 * t3 * t15 * t17 * t20 *
t31 * rtP . w * 2.0 ) + rtP . L * 0.0 * t3 * t15 * t19 * t23 * t30 * rtP . w
* 2.0 ) + rtP . L * 0.0 * 0.0 * t3 * t17 * 0.0 * t34 * rtP . w * 3.0 ) + rtP
. L * 0.0 * t3 * t15 * t20 * t25 * t31 * rtP . w * 2.0 ) + rtP . L * 0.0 * t3
* t15 * t23 * t30 * t34 * rtP . w * 2.0 ) + rtP . L * 0.0 * t3 * t15 * t23 *
t31 * t34 * rtP . w * 2.0 ) + 0.0 * t2 * t15 * t17 * t20 * 0.0 * t30 * 2.0 )
+ 0.0 * t2 * t15 * t19 * t21 * 0.0 * t31 * 2.0 ) + 0.0 * t2 * t15 * t20 * 0.0
* t25 * t30 * 2.0 ) + 0.0 * t2 * t15 * t20 * 0.0 * t25 * t31 * 2.0 ) + 0.0 *
t3 * t10 * t15 * t17 * t22 * 0.0 * t30 ) + 0.0 * t3 * t10 * t15 * t19 * t23 *
0.0 * t30 ) + 0.0 * t3 * t10 * t15 * t22 * 0.0 * t25 * t30 ) + 0.0 * t3 * t10
* t15 * t23 * 0.0 * t30 * t34 ) + rtP . L * 0.0 * 0.0 * t15 * t17 * t22 * 0.0
* t30 * rtP . w ) + rtP . L * 0.0 * 0.0 * t15 * t19 * t23 * 0.0 * t30 * rtP .
w ) + 0.0 * t3 * t10 * t15 * t22 * 0.0 * t25 * t31 ) + 0.0 * t3 * t10 * t15 *
t23 * 0.0 * t31 * t34 ) + rtP . L * 0.0 * 0.0 * t15 * t22 * 0.0 * t25 * t30 *
rtP . w ) + rtP . L * 0.0 * 0.0 * t15 * t23 * 0.0 * t30 * t34 * rtP . w ) +
rtP . L * 0.0 * 0.0 * t15 * t22 * 0.0 * t25 * t31 * rtP . w ) + rtP . L * 0.0
* 0.0 * t15 * t23 * 0.0 * t31 * t34 * rtP . w ) + rtP . L * 0.0 * 0.0 * t3 *
t15 * t17 * t20 * 0.0 * t30 * rtP . w * 2.0 ) + rtP . L * 0.0 * 0.0 * t3 *
t15 * t19 * t21 * 0.0 * t31 * rtP . w * 2.0 ) + rtP . L * 0.0 * 0.0 * t3 *
t15 * t20 * 0.0 * t25 * t30 * rtP . w * 2.0 ) + rtP . L * 0.0 * 0.0 * t3 *
t15 * t20 * 0.0 * t25 * t31 * rtP . w * 2.0 ) - 0.0 * t2 * t17 * t19 * 2.0 )
- 0.0 * t2 * t25 * t34 * 2.0 ) - 0.0 * t2 * t3 * t17 * t19 * 2.0 ) - 0.0 * t2
* t3 * t25 * t34 * 2.0 ) - rtP . L * 0.0 * t3 * t17 * t19 * rtP . w * 3.0 ) -
rtP . L * 0.0 * t3 * t25 * t34 * rtP . w * 3.0 ) - 0.0 * t2 * t15 * t20 * t25
* t30 * 2.0 ) - 0.0 * t2 * t19 * 0.0 * t25 * 2.0 ) - 0.0 * t2 * t15 * t19 *
t23 * t31 * 2.0 ) - 0.0 * t2 * t3 * t19 * 0.0 * t25 * 2.0 ) - 0.0 * t3 * t10
* t15 * t19 * t21 * t31 ) - 0.0 * t3 * t10 * t17 * 0.0 * t34 ) - 0.0 * t3 *
t10 * t15 * t22 * t25 * t30 ) - rtP . L * 0.0 * t15 * t19 * t21 * t31 * rtP .
w ) - rtP . L * 0.0 * 0.0 * t17 * 0.0 * t34 * rtP . w ) - rtP . L * 0.0 * t15
* t22 * t25 * t30 * rtP . w ) - rtP . L * 0.0 * t3 * t15 * t20 * t25 * t30 *
rtP . w * 2.0 ) - rtP . L * 0.0 * 0.0 * t3 * t19 * 0.0 * t25 * rtP . w * 3.0
) - rtP . L * 0.0 * t3 * t15 * t19 * t23 * t31 * rtP . w * 2.0 ) - 0.0 * t2 *
t15 * t19 * t21 * 0.0 * t30 * 2.0 ) - 0.0 * t2 * t15 * t17 * t20 * 0.0 * t31
* 2.0 ) - 0.0 * t2 * t15 * t21 * 0.0 * t30 * t34 * 2.0 ) - 0.0 * t2 * t15 *
t21 * 0.0 * t31 * t34 * 2.0 ) - 0.0 * t3 * t10 * t15 * t17 * t22 * 0.0 * t31
) - 0.0 * t3 * t10 * t15 * t19 * t23 * 0.0 * t31 ) - rtP . L * 0.0 * 0.0 *
t15 * t17 * t22 * 0.0 * t31 * rtP . w ) - rtP . L * 0.0 * 0.0 * t15 * t19 *
t23 * 0.0 * t31 * rtP . w ) - rtP . L * 0.0 * 0.0 * t3 * t15 * t19 * t21 *
0.0 * t30 * rtP . w * 2.0 ) - rtP . L * 0.0 * 0.0 * t3 * t15 * t17 * t20 *
0.0 * t31 * rtP . w * 2.0 ) - rtP . L * 0.0 * 0.0 * t3 * t15 * t21 * 0.0 *
t30 * t34 * rtP . w * 2.0 ) - rtP . L * 0.0 * 0.0 * t3 * t15 * t21 * 0.0 *
t31 * t34 * rtP . w * 2.0 ; t26 = ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( t2 *
t17 * 0.0 * t30 * 2.0 + t2 * 0.0 * t25 * t31 * 2.0 ) + t2 * t3 * t17 * 0.0 *
t31 * 2.0 ) + t3 * t10 * 0.0 * t25 * t30 ) + rtP . L * 0.0 * t25 * t30 * rtP
. w ) + t3 * t10 * t15 * t23 * 0.0 * t32 ) + t3 * t10 * t15 * t23 * 0.0 * t33
) + rtP . L * t15 * t23 * 0.0 * t32 * rtP . w ) + rtP . L * t3 * t17 * 0.0 *
t30 * rtP . w * 3.0 ) + rtP . L * t15 * t23 * 0.0 * t33 * rtP . w ) + rtP . L
* t3 * 0.0 * t25 * t31 * rtP . w * 3.0 ) + 0.0 * t2 * 0.0 * t17 * 0.0 * t34 *
2.0 ) + 0.0 * t2 * t3 * 0.0 * t17 * 0.0 * t34 * 2.0 ) + 0.0 * t3 * 0.0 * t10
* t19 * 0.0 * t25 ) + rtP . L * 0.0 * 0.0 * t19 * 0.0 * t25 * rtP . w ) + rtP
. L * 0.0 * t3 * 0.0 * t17 * 0.0 * t34 * rtP . w * 3.0 ) + 0.0 * t2 * 0.0 *
t15 * t17 * t20 * 0.0 * t30 * 2.0 ) + 0.0 * t2 * 0.0 * t15 * t19 * t21 * 0.0
* t31 * 2.0 ) + 0.0 * t2 * 0.0 * t15 * t20 * 0.0 * t25 * t30 * 2.0 ) + 0.0 *
t2 * 0.0 * t15 * t20 * 0.0 * t25 * t31 * 2.0 ) + 0.0 * t3 * 0.0 * t10 * t15 *
t17 * t22 * 0.0 * t30 ) + 0.0 * t3 * 0.0 * t10 * t15 * t19 * t23 * 0.0 * t30
) + 0.0 * t3 * 0.0 * t10 * t15 * t22 * 0.0 * t25 * t30 ) + 0.0 * t3 * 0.0 *
t10 * t15 * t23 * 0.0 * t30 * t34 ) + rtP . L * 0.0 * 0.0 * t15 * t17 * t22 *
0.0 * t30 * rtP . w ) + rtP . L * 0.0 * 0.0 * t15 * t19 * t23 * 0.0 * t30 *
rtP . w ) + 0.0 * t3 * 0.0 * t10 * t15 * t22 * 0.0 * t25 * t31 ) + 0.0 * t3 *
0.0 * t10 * t15 * t23 * 0.0 * t31 * t34 ) + rtP . L * 0.0 * 0.0 * t15 * t22 *
0.0 * t25 * t30 * rtP . w ) + rtP . L * 0.0 * 0.0 * t15 * t23 * 0.0 * t30 *
t34 * rtP . w ) + rtP . L * 0.0 * 0.0 * t15 * t22 * 0.0 * t25 * t31 * rtP . w
) + rtP . L * 0.0 * 0.0 * t15 * t23 * 0.0 * t31 * t34 * rtP . w ) + rtP . L *
0.0 * t3 * 0.0 * t15 * t17 * t20 * 0.0 * t30 * rtP . w * 2.0 ) + rtP . L *
0.0 * t3 * 0.0 * t15 * t19 * t21 * 0.0 * t31 * rtP . w * 2.0 ) + rtP . L *
0.0 * t3 * 0.0 * t15 * t20 * 0.0 * t25 * t30 * rtP . w * 2.0 ) + rtP . L *
0.0 * t3 * 0.0 * t15 * t20 * 0.0 * t25 * t31 * rtP . w * 2.0 ) - t2 * t15 *
t21 * 0.0 * t32 * 2.0 ) - t2 * t15 * t21 * 0.0 * t33 * 2.0 ) - t2 * t3 * 0.0
* t25 * t30 * 2.0 ) - t3 * t10 * t17 * 0.0 * t31 ) - rtP . L * t17 * 0.0 *
t31 * rtP . w ) - 0.0 * t2 * 0.0 * t19 * 0.0 * t25 * 2.0 ) - rtP . L * t3 *
t15 * t21 * 0.0 * t33 * rtP . w * 2.0 ) - 0.0 * t2 * t3 * 0.0 * t19 * 0.0 *
t25 * 2.0 ) - 0.0 * t3 * 0.0 * t10 * t17 * 0.0 * t34 ) - rtP . L * 0.0 * 0.0
* t17 * 0.0 * t34 * rtP . w ) - rtP . L * t3 * t15 * t21 * 0.0 * t32 * rtP .
w * 2.0 ) - rtP . L * 0.0 * t3 * 0.0 * t19 * 0.0 * t25 * rtP . w * 3.0 ) -
0.0 * t2 * 0.0 * t15 * t19 * t21 * 0.0 * t30 * 2.0 ) - 0.0 * t2 * 0.0 * t15 *
t17 * t20 * 0.0 * t31 * 2.0 ) - 0.0 * t2 * 0.0 * t15 * t21 * 0.0 * t30 * t34
* 2.0 ) - 0.0 * t2 * 0.0 * t15 * t21 * 0.0 * t31 * t34 * 2.0 ) - 0.0 * t3 *
0.0 * t10 * t15 * t17 * t22 * 0.0 * t31 ) - 0.0 * t3 * 0.0 * t10 * t15 * t19
* t23 * 0.0 * t31 ) - rtP . L * 0.0 * 0.0 * t15 * t17 * t22 * 0.0 * t31 * rtP
. w ) - rtP . L * 0.0 * 0.0 * t15 * t19 * t23 * 0.0 * t31 * rtP . w ) - rtP .
L * 0.0 * t3 * 0.0 * t15 * t19 * t21 * 0.0 * t30 * rtP . w * 2.0 ) - rtP . L
* 0.0 * t3 * 0.0 * t15 * t17 * t20 * 0.0 * t31 * rtP . w * 2.0 ) - rtP . L *
0.0 * t3 * 0.0 * t15 * t21 * 0.0 * t30 * t34 * rtP . w * 2.0 ) - rtP . L *
0.0 * t3 * 0.0 * t15 * t21 * 0.0 * t31 * t34 * rtP . w * 2.0 ; t18 = ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( 0.0 * t2 * 0.0 * t15 * t19 * t23 * 0.0
* t30 * 2.0 + ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( - t83 + t84 ) - t88 ) - t90 ) + t93 ) -
t94 ) - t96 ) + t98 ) - t99 ) - t100 ) + t102 ) - t103 ) + t104 ) - t107 ) +
t108 ) + t109 ) - t111 ) + t112 ) + t113 ) - t115 ) + t116 ) + t117 ) + t118
) - t16 ) - t164 ) - t170 ) - t172 ) + t173 ) - t175 ) + t178 ) + t179 ) +
t182 ) - t159 ) - t156 ) - t155 ) - t210 ) - t211 ) - t212 ) - t213 ) - t214
) - t215 ) - t216 ) - t217 ) + t342 ) + t343 ) + t344 ) + t345 ) + t346 ) +
t349 ) + t353 ) + t355 ) + t357 ) + t2 * t15 * t21 * t32 * 2.0 ) + t10 * t17
* t30 * ( t4 + 1.0 ) ) + t2 * t15 * t21 * t33 * 2.0 ) + t10 * t25 * t31 * (
t4 + 1.0 ) ) + t2 * t3 * t25 * t30 * 2.0 ) + t3 * t10 * t17 * t31 ) + rtP . L
* t17 * t31 * rtP . w ) + t2 * t25 * t31 * t153 * t151 * 2.0 ) + t10 * t15 *
t21 * t33 * ( t4 + 1.0 ) ) + rtP . L * t17 * t31 * ( t4 + 1.0 ) * rtP . w *
3.0 ) + 0.0 * t2 * t17 * 0.0 * t31 * 2.0 ) + t2 * t23 * t32 * t149 * t199 ) +
t2 * t17 * t30 * t153 * t151 * 2.0 ) + t2 * t23 * t33 * t149 * t199 ) + t10 *
t15 * t21 * t32 * ( t4 + 1.0 ) ) + rtP . L * t15 * t23 * t33 * ( t4 + 1.0 ) *
rtP . w * 2.0 ) + rtP . L * t25 * t30 * t153 * t151 * rtP . w ) + rtP . L *
t3 * t15 * t21 * t32 * rtP . w * 2.0 ) + rtP . L * t3 * t15 * t21 * t33 * rtP
. w * 2.0 ) + 0.0 * t10 * t17 * t19 * ( t4 + 1.0 ) ) + 0.0 * t10 * t25 * t34
* ( t4 + 1.0 ) ) + 0.0 * t2 * t17 * 0.0 * t31 * ( t4 + 1.0 ) * 2.0 ) + 0.0 *
t2 * t15 * t23 * 0.0 * t32 * 2.0 ) + 0.0 * t10 * 0.0 * t25 * t30 * ( t4 + 1.0
) ) + 0.0 * t2 * t15 * t23 * 0.0 * t33 * 2.0 ) + 0.0 * t3 * t10 * t17 * 0.0 *
t30 ) + t2 * t3 * t17 * t31 * t153 * t151 * 2.0 ) + t3 * t10 * t21 * t32 *
t149 * t199 * 0.5 ) + rtP . L * 0.0 * t17 * 0.0 * t30 * rtP . w ) + t3 * t10
* t21 * t33 * t149 * t199 * 0.5 ) + 0.0 * t3 * t10 * 0.0 * t25 * t31 ) + rtP
. L * t21 * t32 * t149 * t199 * rtP . w * 0.5 ) + rtP . L * t21 * t33 * t149
* t199 * rtP . w * 0.5 ) + rtP . L * 0.0 * 0.0 * t25 * t31 * rtP . w ) + t3 *
t10 * t25 * t30 * t153 * t151 ) + rtP . L * t15 * t23 * t32 * ( t4 + 1.0 ) *
rtP . w * 2.0 ) + 0.0 * t2 * 0.0 * t25 * t30 * t153 * t151 * 2.0 ) + 0.0 *
t10 * t15 * t23 * 0.0 * t32 * ( t4 + 1.0 ) ) + 0.0 * t10 * t15 * t23 * 0.0 *
t33 * ( t4 + 1.0 ) ) + rtP . L * 0.0 * t17 * 0.0 * t30 * ( t4 + 1.0 ) * rtP .
w * 3.0 ) + 0.0 * t3 * t10 * t15 * t21 * 0.0 * t32 ) + rtP . L * 0.0 * 0.0 *
t25 * t31 * ( t4 + 1.0 ) * rtP . w * 3.0 ) + 0.0 * t3 * t10 * t15 * t21 * 0.0
* t33 ) + rtP . L * 0.0 * t15 * t21 * 0.0 * t32 * rtP . w ) + rtP . L * 0.0 *
t15 * t21 * 0.0 * t33 * rtP . w ) + 0.0 * t2 * 0.0 * t15 * t19 * t21 * t30 *
2.0 ) + rtP . L * 0.0 * t3 * t17 * 0.0 * t31 * rtP . w * 3.0 ) + 0.0 * t2 *
0.0 * t15 * t21 * t30 * t34 * 2.0 ) + rtP . L * t3 * t23 * t32 * t149 * t199
* rtP . w ) + rtP . L * t3 * t17 * t30 * t153 * t151 * rtP . w * 3.0 ) + 0.0
* t2 * 0.0 * t15 * t21 * t31 * t34 * 2.0 ) + rtP . L * t3 * t23 * t33 * t149
* t199 * rtP . w ) + rtP . L * t3 * t25 * t31 * t153 * t151 * rtP . w * 3.0 )
+ 0.0 * t2 * t3 * 0.0 * t25 * t31 * t153 * t151 * 2.0 ) + 0.0 * t3 * t10 *
t23 * 0.0 * t32 * t149 * t199 * 0.5 ) + 0.0 * t3 * t10 * t23 * 0.0 * t33 *
t149 * t199 * 0.5 ) + rtP . L * 0.0 * t23 * 0.0 * t32 * t149 * t199 * rtP . w
* 0.5 ) + rtP . L * 0.0 * t23 * 0.0 * t33 * t149 * t199 * rtP . w * 0.5 ) +
0.0 * t2 * 0.0 * t17 * t20 * t30 * t149 * t199 ) + 0.0 * t2 * 0.0 * t17 * t20
* t31 * t149 * t199 ) + 0.0 * t2 * 0.0 * t19 * t23 * t30 * t149 * t199 ) +
0.0 * t2 * 0.0 * t20 * t25 * t31 * t149 * t199 ) + 0.0 * t2 * 0.0 * t23 * t30
* t34 * t149 * t199 ) + 0.0 * t2 * 0.0 * t17 * 0.0 * t34 * ( t4 + 1.0 ) * 2.0
) + 0.0 * t10 * t15 * t19 * t21 * t30 * ( t4 + 1.0 ) ) + 0.0 * t2 * 0.0 * t23
* t31 * t34 * t149 * t199 ) + rtP . L * 0.0 * t3 * t15 * t23 * 0.0 * t32 *
rtP . w * 2.0 ) + 0.0 * t10 * t15 * t17 * t22 * t30 * ( t4 + 1.0 ) ) + 0.0 *
t10 * t15 * t21 * t30 * t34 * ( t4 + 1.0 ) ) + rtP . L * 0.0 * t3 * t15 * t23
* 0.0 * t33 * rtP . w * 2.0 ) + 0.0 * t10 * t19 * 0.0 * t25 * ( t4 + 1.0 ) )
+ 0.0 * t10 * t15 * t17 * t22 * t31 * ( t4 + 1.0 ) ) + 0.0 * t10 * t15 * t21
* t31 * t34 * ( t4 + 1.0 ) ) + 0.0 * t10 * t15 * t22 * t25 * t31 * ( t4 + 1.0
) ) + 0.0 * t3 * 0.0 * t10 * t15 * t19 * t23 * t31 ) + rtP . L * 0.0 * 0.0 *
t15 * t19 * t23 * t31 * rtP . w ) + 0.0 * t2 * t3 * t17 * 0.0 * t30 * t153 *
t151 * 2.0 ) ) + 0.0 * t2 * 0.0 * t15 * t23 * 0.0 * t30 * t34 * 2.0 ) + 0.0 *
t2 * 0.0 * t15 * t17 * t20 * t30 * t153 * t151 * 2.0 ) + rtP . L * 0.0 * t3 *
0.0 * t25 * t30 * t153 * t151 * rtP . w * 3.0 ) + 0.0 * t2 * 0.0 * t15 * t23
* 0.0 * t31 * t34 * 2.0 ) + 0.0 * t2 * 0.0 * t15 * t20 * t25 * t30 * t153 *
t151 * 2.0 ) + 0.0 * t2 * 0.0 * t15 * t20 * t25 * t31 * t153 * t151 * 2.0 ) +
0.0 * t2 * 0.0 * t15 * t23 * t30 * t34 * t153 * t151 * 2.0 ) + 0.0 * t3 * 0.0
* t10 * t19 * t21 * t30 * t149 * t199 * 0.5 ) + 0.0 * t3 * 0.0 * t10 * t17 *
t22 * t30 * t149 * t199 * 0.5 ) + 0.0 * t3 * 0.0 * t10 * t21 * t30 * t34 *
t149 * t199 * 0.5 ) + rtP . L * 0.0 * 0.0 * t19 * t21 * t30 * t149 * t199 *
rtP . w * 0.5 ) + rtP . L * 0.0 * 0.0 * t15 * t17 * t20 * t30 * ( t4 + 1.0 )
* rtP . w * 2.0 ) + 0.0 * t3 * 0.0 * t10 * t17 * t22 * t31 * t149 * t199 *
0.5 ) + 0.0 * t3 * 0.0 * t10 * t21 * t31 * t34 * t149 * t199 * 0.5 ) + rtP .
L * 0.0 * 0.0 * t17 * t22 * t30 * t149 * t199 * rtP . w * 0.5 ) + rtP . L *
0.0 * 0.0 * t21 * t30 * t34 * t149 * t199 * rtP . w * 0.5 ) + rtP . L * 0.0 *
0.0 * t15 * t17 * t20 * t31 * ( t4 + 1.0 ) * rtP . w * 2.0 ) + rtP . L * 0.0
* 0.0 * t15 * t19 * t23 * t30 * ( t4 + 1.0 ) * rtP . w * 2.0 ) + 0.0 * t3 *
0.0 * t10 * t22 * t25 * t31 * t149 * t199 * 0.5 ) + rtP . L * 0.0 * 0.0 * t17
* t22 * t31 * t149 * t199 * rtP . w * 0.5 ) + rtP . L * 0.0 * 0.0 * t21 * t31
* t34 * t149 * t199 * rtP . w * 0.5 ) + rtP . L * 0.0 * 0.0 * 0.0 * t17 * 0.0
* t34 * ( t4 + 1.0 ) * rtP . w * 3.0 ) + rtP . L * 0.0 * 0.0 * t15 * t20 *
t25 * t31 * ( t4 + 1.0 ) * rtP . w * 2.0 ) + rtP . L * 0.0 * 0.0 * t15 * t23
* t30 * t34 * ( t4 + 1.0 ) * rtP . w * 2.0 ) + rtP . L * 0.0 * 0.0 * t22 *
t25 * t31 * t149 * t199 * rtP . w * 0.5 ) + rtP . L * 0.0 * 0.0 * t15 * t23 *
t31 * t34 * ( t4 + 1.0 ) * rtP . w * 2.0 ) + rtP . L * 0.0 * t3 * 0.0 * t15 *
t19 * t21 * t30 * rtP . w * 2.0 ) + rtP . L * 0.0 * t3 * 0.0 * t15 * t21 *
t30 * t34 * rtP . w * 2.0 ) + rtP . L * 0.0 * t3 * 0.0 * t15 * t21 * t31 *
t34 * rtP . w * 2.0 ) + 0.0 * t3 * 0.0 * t10 * t15 * t21 * 0.0 * t30 * t34 )
+ rtP . L * 0.0 * 0.0 * 0.0 * t15 * t19 * t21 * 0.0 * t30 * rtP . w ) + 0.0 *
t3 * 0.0 * t10 * t15 * t21 * 0.0 * t31 * t34 ) + rtP . L * 0.0 * 0.0 * 0.0 *
t15 * t21 * 0.0 * t30 * t34 * rtP . w ) + rtP . L * 0.0 * 0.0 * 0.0 * t15 *
t21 * 0.0 * t31 * t34 * rtP . w ) + 0.0 * t3 * 0.0 * t10 * t15 * t17 * t22 *
t30 * t153 * t151 ) + 0.0 * t3 * 0.0 * t10 * t15 * t21 * t30 * t34 * t153 *
t151 ) + rtP . L * 0.0 * t3 * 0.0 * t17 * t20 * t30 * t149 * t199 * rtP . w )
+ 0.0 * t3 * 0.0 * t10 * t15 * t22 * t25 * t30 * t153 * t151 ) + rtP . L *
0.0 * 0.0 * t15 * t17 * t22 * t30 * t153 * t151 * rtP . w ) + rtP . L * 0.0 *
0.0 * t15 * t21 * t30 * t34 * t153 * t151 * rtP . w ) + rtP . L * 0.0 * t3 *
0.0 * t17 * t20 * t31 * t149 * t199 * rtP . w ) + rtP . L * 0.0 * t3 * 0.0 *
t19 * t23 * t30 * t149 * t199 * rtP . w ) + 0.0 * t3 * 0.0 * t10 * t15 * t22
* t25 * t31 * t153 * t151 ) + rtP . L * 0.0 * 0.0 * t15 * t22 * t25 * t30 *
t153 * t151 * rtP . w ) + rtP . L * 0.0 * t3 * 0.0 * t20 * t25 * t31 * t149 *
t199 * rtP . w ) + rtP . L * 0.0 * t3 * 0.0 * t23 * t30 * t34 * t149 * t199 *
rtP . w ) + rtP . L * 0.0 * 0.0 * t15 * t22 * t25 * t31 * t153 * t151 * rtP .
w ) + rtP . L * 0.0 * t3 * 0.0 * t23 * t31 * t34 * t149 * t199 * rtP . w ) +
0.0 * t2 * 0.0 * t17 * t20 * 0.0 * t30 * t149 * t199 ) + 0.0 * t2 * 0.0 * t19
* t21 * 0.0 * t31 * t149 * t199 ) + 0.0 * t2 * 0.0 * t20 * 0.0 * t25 * t30 *
t149 * t199 ) + 0.0 * t2 * 0.0 * t20 * 0.0 * t25 * t31 * t149 * t199 ) + 0.0
* t10 * t15 * t17 * t22 * 0.0 * t30 * ( t4 + 1.0 ) ) + 0.0 * t10 * t15 * t19
* t23 * 0.0 * t30 * ( t4 + 1.0 ) ) + 0.0 * t10 * t15 * t22 * 0.0 * t25 * t30
* ( t4 + 1.0 ) ) + 0.0 * t10 * t15 * t23 * 0.0 * t30 * t34 * ( t4 + 1.0 ) ) +
0.0 * t10 * t15 * t22 * 0.0 * t25 * t31 * ( t4 + 1.0 ) ) + 0.0 * t10 * t15 *
t23 * 0.0 * t31 * t34 * ( t4 + 1.0 ) ) + 0.0 * t3 * 0.0 * t10 * t15 * t19 *
t21 * 0.0 * t30 ) + rtP . L * 0.0 * 0.0 * t3 * 0.0 * t15 * t23 * 0.0 * t30 *
t34 * rtP . w * 2.0 ) + rtP . L * 0.0 * t3 * 0.0 * t15 * t17 * t20 * t30 *
t153 * t151 * rtP . w * 2.0 ) + rtP . L * 0.0 * 0.0 * t3 * 0.0 * t15 * t23 *
0.0 * t31 * t34 * rtP . w * 2.0 ) + rtP . L * 0.0 * t3 * 0.0 * t15 * t20 *
t25 * t30 * t153 * t151 * rtP . w * 2.0 ) + rtP . L * 0.0 * t3 * 0.0 * t15 *
t20 * t25 * t31 * t153 * t151 * rtP . w * 2.0 ) + rtP . L * 0.0 * t3 * 0.0 *
t15 * t23 * t30 * t34 * t153 * t151 * rtP . w * 2.0 ) + 0.0 * t2 * 0.0 * t15
* t19 * t21 * 0.0 * t30 * t153 * t151 * 2.0 ) + 0.0 * t2 * 0.0 * t15 * t19 *
t21 * 0.0 * t31 * t153 * t151 * 2.0 ) + 0.0 * t2 * 0.0 * t15 * t20 * 0.0 *
t25 * t30 * t153 * t151 * 2.0 ) + 0.0 * t2 * 0.0 * t15 * t21 * 0.0 * t31 *
t34 * t153 * t151 * 2.0 ) + 0.0 * t3 * 0.0 * t10 * t17 * t22 * 0.0 * t30 *
t149 * t199 * 0.5 ) + 0.0 * t3 * 0.0 * t10 * t19 * t23 * 0.0 * t30 * t149 *
t199 * 0.5 ) + rtP . L * 0.0 * 0.0 * 0.0 * t15 * t17 * t20 * 0.0 * t30 * ( t4
+ 1.0 ) * rtP . w * 2.0 ) + 0.0 * t3 * 0.0 * t10 * t22 * 0.0 * t25 * t30 *
t149 * t199 * 0.5 ) + 0.0 * t3 * 0.0 * t10 * t23 * 0.0 * t30 * t34 * t149 *
t199 * 0.5 ) + rtP . L * 0.0 * 0.0 * 0.0 * t17 * t22 * 0.0 * t30 * t149 *
t199 * rtP . w * 0.5 ) + rtP . L * 0.0 * 0.0 * 0.0 * t19 * t23 * 0.0 * t30 *
t149 * t199 * rtP . w * 0.5 ) + rtP . L * 0.0 * 0.0 * 0.0 * t15 * t19 * t21 *
0.0 * t31 * ( t4 + 1.0 ) * rtP . w * 2.0 ) + rtP . L * 0.0 * 0.0 * 0.0 * t15
* t20 * 0.0 * t25 * t30 * ( t4 + 1.0 ) * rtP . w * 2.0 ) + 0.0 * t3 * 0.0 *
t10 * t22 * 0.0 * t25 * t31 * t149 * t199 * 0.5 ) + 0.0 * t3 * 0.0 * t10 *
t23 * 0.0 * t31 * t34 * t149 * t199 * 0.5 ) + rtP . L * 0.0 * 0.0 * 0.0 * t22
* 0.0 * t25 * t30 * t149 * t199 * rtP . w * 0.5 ) + rtP . L * 0.0 * 0.0 * 0.0
* t23 * 0.0 * t30 * t34 * t149 * t199 * rtP . w * 0.5 ) + rtP . L * 0.0 * 0.0
* 0.0 * t15 * t20 * 0.0 * t25 * t31 * ( t4 + 1.0 ) * rtP . w * 2.0 ) + rtP .
L * 0.0 * 0.0 * 0.0 * t22 * 0.0 * t25 * t31 * t149 * t199 * rtP . w * 0.5 ) +
rtP . L * 0.0 * 0.0 * 0.0 * t23 * 0.0 * t31 * t34 * t149 * t199 * rtP . w *
0.5 ) + rtP . L * 0.0 * 0.0 * t3 * 0.0 * t15 * t19 * t23 * 0.0 * t30 * rtP .
w * 2.0 ) + rtP . L * 0.0 * 0.0 * t3 * 0.0 * t17 * t20 * 0.0 * t30 * t149 *
t199 * rtP . w ) + 0.0 * t3 * 0.0 * t10 * t15 * t22 * 0.0 * t25 * t30 * t153
* t151 ) + 0.0 * t3 * 0.0 * t10 * t15 * t23 * 0.0 * t30 * t34 * t153 * t151 )
+ rtP . L * 0.0 * 0.0 * t3 * 0.0 * t19 * t21 * 0.0 * t31 * t149 * t199 * rtP
. w ) + rtP . L * 0.0 * 0.0 * t3 * 0.0 * t20 * 0.0 * t25 * t30 * t149 * t199
* rtP . w ) + rtP . L * 0.0 * 0.0 * 0.0 * t15 * t22 * 0.0 * t25 * t30 * t153
* t151 * rtP . w ) + rtP . L * 0.0 * 0.0 * 0.0 * t15 * t23 * 0.0 * t30 * t34
* t153 * t151 * rtP . w ) + rtP . L * 0.0 * 0.0 * t3 * 0.0 * t20 * 0.0 * t25
* t31 * t149 * t199 * rtP . w ) + rtP . L * 0.0 * 0.0 * t3 * 0.0 * t15 * t19
* t21 * 0.0 * t30 * t153 * t151 * rtP . w * 2.0 ) + rtP . L * 0.0 * 0.0 * t3
* 0.0 * t15 * t19 * t21 * 0.0 * t31 * t153 * t151 * rtP . w * 2.0 ) + rtP . L
* 0.0 * 0.0 * t3 * 0.0 * t15 * t20 * 0.0 * t25 * t30 * t153 * t151 * rtP . w
* 2.0 ) + rtP . L * 0.0 * 0.0 * t3 * 0.0 * t15 * t21 * 0.0 * t31 * t34 * t153
* t151 * rtP . w * 2.0 ) - t2 * t17 * t30 * 2.0 ) - t2 * t25 * t31 * 2.0 ) -
t2 * t17 * t30 * ( t4 + 1.0 ) * 2.0 ) - t2 * t25 * t31 * ( t4 + 1.0 ) * 2.0 )
- t2 * t3 * t17 * t31 * 2.0 ) - t3 * t10 * t25 * t30 ) - rtP . L * t25 * t30
* rtP . w ) - rtP . L * t25 * t30 * ( t4 + 1.0 ) * rtP . w * 3.0 ) - t3 * t10
* t15 * t23 * t32 ) - t3 * t10 * t15 * t23 * t33 ) - rtP . L * t15 * t23 *
t32 * rtP . w ) - rtP . L * t3 * t17 * t30 * rtP . w * 3.0 ) - rtP . L * t15
* t23 * t33 * rtP . w ) - rtP . L * t3 * t25 * t31 * rtP . w * 3.0 ) - 0.0 *
t2 * 0.0 * t25 * t30 * 2.0 ) - rtP . L * t17 * t31 * t153 * t151 * rtP . w )
- 0.0 * t2 * 0.0 * t17 * t19 * ( t4 + 1.0 ) * 2.0 ) - 0.0 * t2 * 0.0 * t25 *
t34 * ( t4 + 1.0 ) * 2.0 ) - 0.0 * t2 * 0.0 * t25 * t30 * ( t4 + 1.0 ) * 2.0
) - 0.0 * t10 * t17 * 0.0 * t31 * ( t4 + 1.0 ) ) - 0.0 * t2 * t3 * t17 * 0.0
* t30 * 2.0 ) - 0.0 * t2 * t3 * 0.0 * t25 * t31 * 2.0 ) - t2 * t3 * t25 * t30
* t153 * t151 * 2.0 ) - t3 * t10 * t17 * t31 * t153 * t151 ) - 0.0 * t2 * t21
* 0.0 * t32 * t149 * t199 ) - 0.0 * t2 * t21 * 0.0 * t33 * t149 * t199 ) -
rtP . L * 0.0 * 0.0 * t17 * t19 * ( t4 + 1.0 ) * rtP . w * 3.0 ) - 0.0 * t2 *
t17 * 0.0 * t31 * t153 * t151 * 2.0 ) - rtP . L * 0.0 * 0.0 * t25 * t34 * (
t4 + 1.0 ) * rtP . w * 3.0 ) - rtP . L * 0.0 * t3 * 0.0 * t25 * t30 * rtP . w
* 3.0 ) - 0.0 * t2 * 0.0 * t15 * t19 * t21 * t31 * 2.0 ) - 0.0 * t3 * t10 *
t17 * 0.0 * t30 * t153 * t151 ) - rtP . L * 0.0 * t15 * t21 * 0.0 * t32 * (
t4 + 1.0 ) * rtP . w * 2.0 ) - rtP . L * 0.0 * t15 * t21 * 0.0 * t33 * ( t4 +
1.0 ) * rtP . w * 2.0 ) - rtP . L * 0.0 * t17 * 0.0 * t30 * t153 * t151 * rtP
. w ) - 0.0 * t3 * t10 * 0.0 * t25 * t31 * t153 * t151 ) - 0.0 * t2 * 0.0 *
t20 * t25 * t30 * t149 * t199 ) - rtP . L * 0.0 * 0.0 * t25 * t31 * t153 *
t151 * rtP . w ) - 0.0 * t2 * 0.0 * t19 * t23 * t31 * t149 * t199 ) - 0.0 *
t2 * 0.0 * t19 * 0.0 * t25 * ( t4 + 1.0 ) * 2.0 ) - 0.0 * t10 * t15 * t19 *
t21 * t31 * ( t4 + 1.0 ) ) - 0.0 * t10 * t17 * 0.0 * t34 * ( t4 + 1.0 ) ) -
0.0 * t10 * t15 * t22 * t25 * t30 * ( t4 + 1.0 ) ) - 0.0 * t3 * 0.0 * t10 *
t15 * t19 * t23 * t30 ) - 0.0 * t3 * 0.0 * t10 * t15 * t23 * t30 * t34 ) -
rtP . L * 0.0 * 0.0 * t15 * t19 * t23 * t30 * rtP . w ) - 0.0 * t3 * 0.0 *
t10 * t15 * t23 * t31 * t34 ) - rtP . L * 0.0 * 0.0 * t15 * t23 * t30 * t34 *
rtP . w ) - rtP . L * 0.0 * 0.0 * t15 * t23 * t31 * t34 * rtP . w ) - rtP . L
* 0.0 * t3 * t21 * 0.0 * t33 * t149 * t199 * rtP . w ) - 0.0 * t2 * 0.0 * t15
* t19 * t23 * 0.0 * t31 * 2.0 ) - rtP . L * 0.0 * t3 * t17 * 0.0 * t31 * t153
* t151 * rtP . w * 3.0 ) - 0.0 * t2 * 0.0 * t15 * t17 * t20 * t31 * t153 *
t151 * 2.0 ) - 0.0 * t2 * 0.0 * t15 * t19 * t23 * t30 * t153 * t151 * 2.0 ) -
0.0 * t2 * 0.0 * t15 * t19 * t23 * t31 * t153 * t151 * 2.0 ) - 0.0 * t2 * 0.0
* t15 * t23 * t31 * t34 * t153 * t151 * 2.0 ) - 0.0 * t3 * 0.0 * t10 * t19 *
t21 * t31 * t149 * t199 * 0.5 ) - 0.0 * t3 * 0.0 * t10 * t22 * t25 * t30 *
t149 * t199 * 0.5 ) - rtP . L * 0.0 * 0.0 * t19 * t21 * t31 * t149 * t199 *
rtP . w * 0.5 ) - rtP . L * 0.0 * 0.0 * t15 * t20 * t25 * t30 * ( t4 + 1.0 )
* rtP . w * 2.0 ) - rtP . L * 0.0 * 0.0 * t22 * t25 * t30 * t149 * t199 * rtP
. w * 0.5 ) - rtP . L * 0.0 * 0.0 * 0.0 * t19 * 0.0 * t25 * ( t4 + 1.0 ) *
rtP . w * 3.0 ) - rtP . L * 0.0 * 0.0 * t15 * t19 * t23 * t31 * ( t4 + 1.0 )
* rtP . w * 2.0 ) - rtP . L * 0.0 * t3 * 0.0 * t15 * t19 * t21 * t31 * rtP .
w * 2.0 ) - rtP . L * 0.0 * t3 * t21 * 0.0 * t32 * t149 * t199 * rtP . w ) -
0.0 * t3 * 0.0 * t10 * t15 * t19 * t21 * 0.0 * t31 ) - rtP . L * 0.0 * 0.0 *
0.0 * t15 * t19 * t21 * 0.0 * t31 * rtP . w ) - 0.0 * t3 * 0.0 * t10 * t15 *
t19 * t21 * t30 * t153 * t151 ) - 0.0 * t3 * 0.0 * t10 * t15 * t19 * t21 *
t31 * t153 * t151 ) - rtP . L * 0.0 * 0.0 * t15 * t19 * t21 * t30 * t153 *
t151 * rtP . w ) - 0.0 * t3 * 0.0 * t10 * t15 * t17 * t22 * t31 * t153 * t151
) - 0.0 * t3 * 0.0 * t10 * t15 * t21 * t31 * t34 * t153 * t151 ) - rtP . L *
0.0 * 0.0 * t15 * t19 * t21 * t31 * t153 * t151 * rtP . w ) - rtP . L * 0.0 *
t3 * 0.0 * t20 * t25 * t30 * t149 * t199 * rtP . w ) - rtP . L * 0.0 * 0.0 *
t15 * t17 * t22 * t31 * t153 * t151 * rtP . w ) - rtP . L * 0.0 * 0.0 * t15 *
t21 * t31 * t34 * t153 * t151 * rtP . w ) - rtP . L * 0.0 * t3 * 0.0 * t19 *
t23 * t31 * t149 * t199 * rtP . w ) - 0.0 * t2 * 0.0 * t19 * t21 * 0.0 * t30
* t149 * t199 ) - 0.0 * t2 * 0.0 * t17 * t20 * 0.0 * t31 * t149 * t199 ) -
0.0 * t2 * 0.0 * t21 * 0.0 * t30 * t34 * t149 * t199 ) - 0.0 * t2 * 0.0 * t21
* 0.0 * t31 * t34 * t149 * t199 ) - 0.0 * t10 * t15 * t17 * t22 * 0.0 * t31 *
( t4 + 1.0 ) ) - 0.0 * t10 * t15 * t19 * t23 * 0.0 * t31 * ( t4 + 1.0 ) ) -
rtP . L * 0.0 * 0.0 * t3 * 0.0 * t15 * t19 * t23 * 0.0 * t31 * rtP . w * 2.0
) - rtP . L * 0.0 * t3 * 0.0 * t15 * t17 * t20 * t31 * t153 * t151 * rtP . w
* 2.0 ) - rtP . L * 0.0 * t3 * 0.0 * t15 * t19 * t23 * t30 * t153 * t151 *
rtP . w * 2.0 ) - rtP . L * 0.0 * t3 * 0.0 * t15 * t19 * t23 * t31 * t153 *
t151 * rtP . w * 2.0 ) - rtP . L * 0.0 * t3 * 0.0 * t15 * t23 * t31 * t34 *
t153 * t151 * rtP . w * 2.0 ) - 0.0 * t2 * 0.0 * t15 * t17 * t20 * 0.0 * t30
* t153 * t151 * 2.0 ) - 0.0 * t2 * 0.0 * t15 * t17 * t20 * 0.0 * t31 * t153 *
t151 * 2.0 ) - 0.0 * t2 * 0.0 * t15 * t21 * 0.0 * t30 * t34 * t153 * t151 *
2.0 ) - 0.0 * t2 * 0.0 * t15 * t20 * 0.0 * t25 * t31 * t153 * t151 * 2.0 ) -
rtP . L * 0.0 * 0.0 * 0.0 * t15 * t19 * t21 * 0.0 * t30 * ( t4 + 1.0 ) * rtP
. w * 2.0 ) - 0.0 * t3 * 0.0 * t10 * t17 * t22 * 0.0 * t31 * t149 * t199 *
0.5 ) - 0.0 * t3 * 0.0 * t10 * t19 * t23 * 0.0 * t31 * t149 * t199 * 0.5 ) -
rtP . L * 0.0 * 0.0 * 0.0 * t15 * t17 * t20 * 0.0 * t31 * ( t4 + 1.0 ) * rtP
. w * 2.0 ) - rtP . L * 0.0 * 0.0 * 0.0 * t15 * t21 * 0.0 * t30 * t34 * ( t4
+ 1.0 ) * rtP . w * 2.0 ) - rtP . L * 0.0 * 0.0 * 0.0 * t17 * t22 * 0.0 * t31
* t149 * t199 * rtP . w * 0.5 ) - rtP . L * 0.0 * 0.0 * 0.0 * t19 * t23 * 0.0
* t31 * t149 * t199 * rtP . w * 0.5 ) - rtP . L * 0.0 * 0.0 * 0.0 * t15 * t21
* 0.0 * t31 * t34 * ( t4 + 1.0 ) * rtP . w * 2.0 ) - 0.0 * t3 * 0.0 * t10 *
t15 * t17 * t22 * 0.0 * t30 * t153 * t151 ) - 0.0 * t3 * 0.0 * t10 * t15 *
t19 * t23 * 0.0 * t30 * t153 * t151 ) - rtP . L * 0.0 * 0.0 * t3 * 0.0 * t19
* t21 * 0.0 * t30 * t149 * t199 * rtP . w ) - 0.0 * t3 * 0.0 * t10 * t15 *
t17 * t22 * 0.0 * t31 * t153 * t151 ) - 0.0 * t3 * 0.0 * t10 * t15 * t19 *
t23 * 0.0 * t31 * t153 * t151 ) - rtP . L * 0.0 * 0.0 * 0.0 * t15 * t17 * t22
* 0.0 * t30 * t153 * t151 * rtP . w ) - rtP . L * 0.0 * 0.0 * 0.0 * t15 * t19
* t23 * 0.0 * t30 * t153 * t151 * rtP . w ) - rtP . L * 0.0 * 0.0 * t3 * 0.0
* t17 * t20 * 0.0 * t31 * t149 * t199 * rtP . w ) - rtP . L * 0.0 * 0.0 * t3
* 0.0 * t21 * 0.0 * t30 * t34 * t149 * t199 * rtP . w ) - 0.0 * t3 * 0.0 *
t10 * t15 * t22 * 0.0 * t25 * t31 * t153 * t151 ) - 0.0 * t3 * 0.0 * t10 *
t15 * t23 * 0.0 * t31 * t34 * t153 * t151 ) - rtP . L * 0.0 * 0.0 * 0.0 * t15
* t17 * t22 * 0.0 * t31 * t153 * t151 * rtP . w ) - rtP . L * 0.0 * 0.0 * 0.0
* t15 * t19 * t23 * 0.0 * t31 * t153 * t151 * rtP . w ) - rtP . L * 0.0 * 0.0
* t3 * 0.0 * t21 * 0.0 * t31 * t34 * t149 * t199 * rtP . w ) - rtP . L * 0.0
* 0.0 * 0.0 * t15 * t22 * 0.0 * t25 * t31 * t153 * t151 * rtP . w ) - rtP . L
* 0.0 * 0.0 * 0.0 * t15 * t23 * 0.0 * t31 * t34 * t153 * t151 * rtP . w ) -
rtP . L * 0.0 * 0.0 * t3 * 0.0 * t15 * t17 * t20 * 0.0 * t30 * t153 * t151 *
rtP . w * 2.0 ) - rtP . L * 0.0 * 0.0 * t3 * 0.0 * t15 * t17 * t20 * 0.0 *
t31 * t153 * t151 * rtP . w * 2.0 ) - rtP . L * 0.0 * 0.0 * t3 * 0.0 * t15 *
t21 * 0.0 * t30 * t34 * t153 * t151 * rtP . w * 2.0 ) - rtP . L * 0.0 * 0.0 *
t3 * 0.0 * t15 * t20 * 0.0 * t25 * t31 * t153 * t151 * rtP . w * 2.0 ; t28 =
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( t35 - t36 ) + t37 ) + t38 ) - t9 ) + t40 ) + t41 ) - t42 ) + t43 ) -
t11 ) + t45 ) - t46 ) + t47 ) + t48 ) - t49 ) + t50 ) + t51 ) - t52 ) + t53 )
- t54 ) + t87 ) + t91 ) + t95 ) + t101 ) + t106 ) + t110 ) + t114 ) + t120 )
- t174 ) - t177 ) - t180 ) - t181 ) + t159 ) + t156 ) + t155 ) + t210 ) +
t211 ) + t212 ) + t213 ) + t214 ) + t215 ) + t216 ) + t217 ) - t342 ) - t343
) - t344 ) - t345 ) - t346 ) + t347 ) + t348 ) - t349 ) + t350 ) + t351 ) +
t352 ) - t353 ) + t354 ) - t355 ) + t356 ) - t357 ) + t358 ) + t359 ) + t360
) + t361 ) + t362 ) + t363 ) + t364 ) + t365 ) + t366 ) - 0.0 * t2 * 0.0 *
t15 * t17 * t22 * t30 * 2.0 ) - 0.0 * t2 * 0.0 * t15 * t17 * t22 * t31 * 2.0
) - 0.0 * t2 * 0.0 * t15 * t22 * t25 * t31 * 2.0 ) - 0.0 * t3 * 0.0 * t10 *
t15 * t20 * t25 * t30 ) - rtP . L * 0.0 * 0.0 * t15 * t20 * t25 * t30 * rtP .
w ) - 0.0 * t2 * 0.0 * t15 * t17 * t22 * 0.0 * t30 * 2.0 ) - 0.0 * t2 * 0.0 *
t15 * t22 * 0.0 * t25 * t30 * 2.0 ) - 0.0 * t2 * 0.0 * t15 * t22 * 0.0 * t25
* t31 * 2.0 ) - rtP . L * 0.0 * t3 * 0.0 * t15 * t17 * t22 * t30 * rtP . w *
2.0 ) - rtP . L * 0.0 * t3 * 0.0 * t15 * t17 * t22 * t31 * rtP . w * 2.0 ) -
rtP . L * 0.0 * t3 * 0.0 * t15 * t22 * t25 * t31 * rtP . w * 2.0 ) - 0.0 * t3
* 0.0 * t10 * t15 * t17 * t20 * 0.0 * t31 ) - rtP . L * 0.0 * 0.0 * 0.0 * t15
* t17 * t20 * 0.0 * t31 * rtP . w ) - rtP . L * 0.0 * 0.0 * t3 * 0.0 * t15 *
t22 * 0.0 * t25 * t30 * rtP . w * 2.0 ) - rtP . L * 0.0 * 0.0 * t3 * 0.0 *
t15 * t22 * 0.0 * t25 * t31 * rtP . w * 2.0 ) - rtP . L * 0.0 * 0.0 * t3 *
0.0 * t15 * t17 * t22 * 0.0 * t30 * rtP . w * 2.0 ; t29 = ( ( ( ( ( ( 0.0 *
t17 * 0.0 * t30 + t17 * t31 ) + 0.0 * t25 * t31 ) + 0.0 * t17 * 0.0 * t34 ) -
t25 * t30 ) - 0.0 * t17 * t19 ) - 0.0 * t25 * t34 ) - 0.0 * t19 * 0.0 * t25 ;
t27 = 0.0 * t17 * t34 ; t12 = 0.0 * t17 * t19 * 0.0 ; t170 = 0.0 * t25 * t34
; t172 = 1.0 / ( rtP . L * rtP . L ) ; t173 = 1.0 / ( t4 + 1.0 ) ; t174 = t17
* t17 ; t175 = t25 * t25 ; t178 = ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( t3 * t10 * t174 + t3 * t10 * t175
) + rtP . L * t174 * rtP . w ) + rtP . L * t175 * rtP . w ) + t2 * t15 * t17
* t21 * t31 * 2.0 ) + t2 * t15 * t17 * t23 * t30 * 2.0 ) + t2 * t15 * t23 *
t25 * t31 * 2.0 ) + 0.0 * t2 * 0.0 * t15 * t20 * t174 * 2.0 ) + 0.0 * t2 *
0.0 * t15 * t20 * t175 * 2.0 ) + t3 * t10 * t15 * t17 * t21 * t30 ) + rtP . L
* t15 * t17 * t21 * t30 * rtP . w ) + t3 * t10 * t15 * t21 * t25 * t31 ) + t3
* t10 * t15 * t23 * t25 * t30 ) + rtP . L * t15 * t21 * t25 * t31 * rtP . w )
+ rtP . L * t15 * t23 * t25 * t30 * rtP . w ) + 0.0 * t3 * 0.0 * t10 * t15 *
t22 * t174 ) + 0.0 * t3 * 0.0 * t10 * t15 * t22 * t175 ) + rtP . L * 0.0 *
0.0 * t15 * t22 * t174 * rtP . w ) + rtP . L * t3 * t15 * t17 * t21 * t31 *
rtP . w * 2.0 ) + rtP . L * t3 * t15 * t17 * t23 * t30 * rtP . w * 2.0 ) +
rtP . L * 0.0 * 0.0 * t15 * t22 * t175 * rtP . w ) + rtP . L * t3 * t15 * t23
* t25 * t31 * rtP . w * 2.0 ) + 0.0 * t2 * 0.0 * t15 * t17 * t23 * t34 * 2.0
) + rtP . L * 0.0 * t3 * 0.0 * t15 * t20 * t174 * rtP . w * 2.0 ) + rtP . L *
0.0 * t3 * 0.0 * t15 * t20 * t175 * rtP . w * 2.0 ) + 0.0 * t3 * 0.0 * t10 *
t15 * t17 * t19 * t23 ) + 0.0 * t3 * 0.0 * t10 * t15 * t17 * t21 * t34 ) +
rtP . L * 0.0 * 0.0 * t15 * t17 * t19 * t23 * rtP . w ) + rtP . L * 0.0 * 0.0
* t15 * t17 * t21 * t34 * rtP . w ) + 0.0 * t3 * 0.0 * t10 * t15 * t23 * t25
* t34 ) + rtP . L * 0.0 * 0.0 * t15 * t23 * t25 * t34 * rtP . w ) + rtP . L *
0.0 * t3 * 0.0 * t15 * t17 * t23 * t34 * rtP . w * 2.0 ) - t2 * t3 * t174 *
2.0 ) - t2 * t3 * t175 * 2.0 ) - t2 * t15 * t21 * t25 * t30 * 2.0 ) - t3 *
t10 * t15 * t17 * t23 * t31 ) - rtP . L * t15 * t17 * t23 * t31 * rtP . w ) -
rtP . L * t3 * t15 * t21 * t25 * t30 * rtP . w * 2.0 ) - 0.0 * t2 * 0.0 * t15
* t17 * t19 * t21 * 2.0 ) - 0.0 * t2 * 0.0 * t15 * t19 * t23 * t25 * 2.0 ) -
0.0 * t2 * 0.0 * t15 * t21 * t25 * t34 * 2.0 ) - 0.0 * t3 * 0.0 * t10 * t15 *
t19 * t21 * t25 ) - rtP . L * 0.0 * 0.0 * t15 * t19 * t21 * t25 * rtP . w ) -
rtP . L * 0.0 * t3 * 0.0 * t15 * t17 * t19 * t21 * rtP . w * 2.0 ) - rtP . L
* 0.0 * t3 * 0.0 * t15 * t19 * t23 * t25 * rtP . w * 2.0 ) - rtP . L * 0.0 *
t3 * 0.0 * t15 * t21 * t25 * t34 * rtP . w * 2.0 ; mxorse3uag [ 0 ] = 0.0 ;
mxorse3uag [ 1 ] = 0.0 ; mxorse3uag [ 2 ] = 0.0 ; mxorse3uag [ 3 ] = ( t195 *
t172 * t173 - t3 * t13 * t172 * t173 * 2.0 ) * ehrq52oenb [ 3 ] ; mxorse3uag
[ 4 ] = 0.0 ; mxorse3uag [ 5 ] = 0.0 ; mxorse3uag [ 6 ] = 0.0 ; mxorse3uag [
7 ] = 0.0 ; mxorse3uag [ 8 ] = 0.0 ; mxorse3uag [ 9 ] = ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( t223 + t224 ) + t225 ) + t226 ) + t160 ) + t231 ) - rtP . R * 0.0
* t2 * 0.0 * t15 * t17 * t22 * 2.0 ) + rtP . L * rtP . R * 0.0 * 0.0 * t15 *
t17 * t20 * rtP . w ) + rtP . R * 0.0 * t3 * 0.0 * t10 * t15 * t17 * t20 ) -
rtP . L * rtP . R * 0.0 * t3 * 0.0 * t15 * t17 * t22 * rtP . w * 2.0 ) - rtP
. R * 0.0 * 0.0 * t2 * 0.0 * t15 * t19 * t21 * 0.0 * 2.0 ) - rtP . R * 0.0 *
0.0 * t2 * 0.0 * t15 * t22 * 0.0 * t25 * 2.0 ) + rtP . L * rtP . R * 0.0 *
0.0 * 0.0 * t15 * t20 * 0.0 * t25 * rtP . w ) + rtP . R * 0.0 * 0.0 * t3 *
0.0 * t10 * t15 * t20 * 0.0 * t25 ) - rtP . L * rtP . R * 0.0 * 0.0 * t3 *
0.0 * t15 * t19 * t21 * 0.0 * rtP . w * 2.0 ) - rtP . L * rtP . R * 0.0 * 0.0
* t3 * 0.0 * t15 * t22 * 0.0 * t25 * rtP . w * 2.0 ) / ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( t35 + t36 ) + t37
) + t38 ) + t9 ) + t40 ) + t41 ) + t42 ) + t43 ) + t11 ) + t45 ) + t46 ) +
t47 ) + t48 ) + t49 ) + t50 ) + t51 ) + t52 ) + t53 ) + t54 ) + t55 ) + t56 )
+ t57 ) + t58 ) + t59 ) + t60 ) + t61 ) + t62 ) + t63 ) + t64 ) + t65 ) + t66
) + t67 ) + t68 ) + t69 ) + t70 ) + t71 ) + t72 ) + t73 ) + t74 ) + t75 ) +
t76 ) + t77 ) + t78 ) + t79 ) + t80 ) + t81 ) + t82 ) + t83 ) + t84 ) + t85 )
+ t86 ) + t88 ) + t89 ) + t90 ) + t92 ) + t93 ) + t94 ) + t96 ) + t97 ) + t98
) + t99 ) + t100 ) + t102 ) + t103 ) + t104 ) + t105 ) + t107 ) + t108 ) +
t109 ) + t111 ) + t112 ) + t113 ) + t115 ) + t116 ) + t117 ) + t118 ) + t16 )
- t2 * t25 * t30 * 2.0 ) - t2 * t3 * t17 * t30 * 2.0 ) - t2 * t3 * t25 * t31
* 2.0 ) - rtP . L * t3 * t25 * t30 * rtP . w * 3.0 ) - 0.0 * t2 * 0.0 * t17 *
t19 * 2.0 ) - 0.0 * t2 * 0.0 * t25 * t34 * 2.0 ) - 0.0 * t2 * t3 * 0.0 * t17
* t19 * 2.0 ) - 0.0 * t2 * t3 * 0.0 * t25 * t34 * 2.0 ) - 0.0 * t2 * t3 * 0.0
* t25 * t30 * 2.0 ) - 0.0 * t3 * t10 * t17 * 0.0 * t31 ) - 0.0 * t2 * t15 *
t21 * 0.0 * t32 * 2.0 ) - 0.0 * t2 * t15 * t21 * 0.0 * t33 * 2.0 ) - rtP . L
* 0.0 * t17 * 0.0 * t31 * rtP . w ) - rtP . L * 0.0 * t3 * 0.0 * t17 * t19 *
rtP . w * 3.0 ) - rtP . L * 0.0 * t3 * 0.0 * t25 * t34 * rtP . w * 3.0 ) -
0.0 * t2 * 0.0 * t19 * 0.0 * t25 * 2.0 ) - 0.0 * t2 * 0.0 * t15 * t19 * t23 *
t31 * 2.0 ) - 0.0 * t2 * 0.0 * t15 * t20 * t25 * t30 * 2.0 ) - rtP . L * 0.0
* 0.0 * 0.0 * t17 * 0.0 * t34 * rtP . w ) - rtP . L * 0.0 * 0.0 * t15 * t19 *
t21 * t31 * rtP . w ) - rtP . L * 0.0 * t3 * t15 * t21 * 0.0 * t32 * rtP . w
* 2.0 ) - rtP . L * 0.0 * t3 * t15 * t21 * 0.0 * t33 * rtP . w * 2.0 ) - rtP
. L * 0.0 * 0.0 * t15 * t22 * t25 * t30 * rtP . w ) - 0.0 * t2 * t3 * 0.0 *
t19 * 0.0 * t25 * 2.0 ) - 0.0 * t3 * 0.0 * t10 * t17 * 0.0 * t34 ) - 0.0 * t3
* 0.0 * t10 * t15 * t19 * t21 * t31 ) - 0.0 * t3 * 0.0 * t10 * t15 * t22 *
t25 * t30 ) - rtP . L * 0.0 * 0.0 * t3 * 0.0 * t19 * 0.0 * t25 * rtP . w *
3.0 ) - rtP . L * 0.0 * t3 * 0.0 * t15 * t19 * t23 * t31 * rtP . w * 2.0 ) -
rtP . L * 0.0 * t3 * 0.0 * t15 * t20 * t25 * t30 * rtP . w * 2.0 ) - 0.0 * t2
* 0.0 * t15 * t17 * t20 * 0.0 * t31 * 2.0 ) - 0.0 * t2 * 0.0 * t15 * t19 *
t21 * 0.0 * t30 * 2.0 ) - 0.0 * t2 * 0.0 * t15 * t21 * 0.0 * t30 * t34 * 2.0
) - 0.0 * t2 * 0.0 * t15 * t21 * 0.0 * t31 * t34 * 2.0 ) - rtP . L * 0.0 *
0.0 * 0.0 * t15 * t17 * t22 * 0.0 * t31 * rtP . w ) - rtP . L * 0.0 * 0.0 *
0.0 * t15 * t19 * t23 * 0.0 * t31 * rtP . w ) - 0.0 * t3 * 0.0 * t10 * t15 *
t17 * t22 * 0.0 * t31 ) - 0.0 * t3 * 0.0 * t10 * t15 * t19 * t23 * 0.0 * t31
) - rtP . L * 0.0 * 0.0 * t3 * 0.0 * t15 * t17 * t20 * 0.0 * t31 * rtP . w *
2.0 ) - rtP . L * 0.0 * 0.0 * t3 * 0.0 * t15 * t19 * t21 * 0.0 * t30 * rtP .
w * 2.0 ) - rtP . L * 0.0 * 0.0 * t3 * 0.0 * t15 * t21 * 0.0 * t30 * t34 *
rtP . w * 2.0 ) - rtP . L * 0.0 * 0.0 * t3 * 0.0 * t15 * t21 * 0.0 * t31 *
t34 * rtP . w * 2.0 ) - ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( t35 - t36 ) + t37 ) + t38 ) - t9 ) + t40 )
+ t41 ) - t42 ) + t43 ) - t11 ) + t45 ) - t46 ) + t47 ) + t48 ) - t49 ) + t50
) + t51 ) - t52 ) + t53 ) - t54 ) + t87 ) + t91 ) + t95 ) + t101 ) + t106 ) +
t110 ) + t114 ) + t120 ) + t159 ) + t156 ) + t155 ) + t210 ) + t211 ) + t212
) + t213 ) + t214 ) + t215 ) + t216 ) + t217 ) + t347 ) + t348 ) + t350 ) +
t351 ) + t352 ) + t354 ) + t356 ) + t358 ) + t359 ) + t360 ) + t361 ) + t362
) + t363 ) + t364 ) + t365 ) + t366 ) - 0.0 * t2 * 0.0 * t19 * t25 * 2.0 ) -
0.0 * t2 * t3 * 0.0 * t19 * t25 * 2.0 ) - 0.0 * t3 * 0.0 * t10 * t17 * t34 )
- rtP . L * 0.0 * 0.0 * t17 * t34 * rtP . w ) - rtP . L * 0.0 * t3 * 0.0 *
t19 * t25 * rtP . w * 3.0 ) - 0.0 * t2 * 0.0 * t15 * t17 * t22 * t30 * 2.0 )
- 0.0 * t2 * 0.0 * t15 * t17 * t22 * t31 * 2.0 ) - 0.0 * t2 * 0.0 * t15 * t22
* t25 * t31 * 2.0 ) - rtP . L * 0.0 * 0.0 * 0.0 * t17 * t19 * 0.0 * rtP . w )
- rtP . L * 0.0 * 0.0 * 0.0 * 0.0 * t25 * t34 * rtP . w ) - rtP . L * 0.0 *
0.0 * t15 * t20 * t25 * t30 * rtP . w ) - 0.0 * t3 * 0.0 * t10 * t17 * t19 *
0.0 ) - 0.0 * t3 * 0.0 * t10 * 0.0 * t25 * t34 ) - 0.0 * t3 * 0.0 * t10 * t15
* t20 * t25 * t30 ) - rtP . L * 0.0 * t3 * 0.0 * t15 * t17 * t22 * t30 * rtP
. w * 2.0 ) - rtP . L * 0.0 * t3 * 0.0 * t15 * t17 * t22 * t31 * rtP . w *
2.0 ) - rtP . L * 0.0 * t3 * 0.0 * t15 * t22 * t25 * t31 * rtP . w * 2.0 ) -
0.0 * t2 * 0.0 * t15 * t17 * t22 * 0.0 * t30 * 2.0 ) - 0.0 * t2 * 0.0 * t15 *
t19 * t21 * 0.0 * t30 * 2.0 ) - 0.0 * t2 * 0.0 * t15 * t22 * 0.0 * t25 * t30
* 2.0 ) - 0.0 * t2 * 0.0 * t15 * t22 * 0.0 * t25 * t31 * 2.0 ) - 0.0 * t2 *
0.0 * t15 * t21 * 0.0 * t31 * t34 * 2.0 ) - rtP . L * 0.0 * 0.0 * 0.0 * t15 *
t17 * t20 * 0.0 * t31 * rtP . w ) - 0.0 * t3 * 0.0 * t10 * t15 * t17 * t20 *
0.0 * t31 ) - rtP . L * 0.0 * 0.0 * t3 * 0.0 * t15 * t17 * t22 * 0.0 * t30 *
rtP . w * 2.0 ) - rtP . L * 0.0 * 0.0 * t3 * 0.0 * t15 * t19 * t21 * 0.0 *
t30 * rtP . w * 2.0 ) - rtP . L * 0.0 * 0.0 * t3 * 0.0 * t15 * t22 * 0.0 *
t25 * t30 * rtP . w * 2.0 ) - rtP . L * 0.0 * 0.0 * t3 * 0.0 * t15 * t22 *
0.0 * t25 * t31 * rtP . w * 2.0 ) - rtP . L * 0.0 * 0.0 * t3 * 0.0 * t15 *
t21 * 0.0 * t31 * t34 * rtP . w * 2.0 ) * ( t148 * t139 ) ) * rtB .
hkbmt1bwgv [ 9 ] + ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( t220 + t221 ) + t222 ) + t227 ) + t228 ) + t230 )
+ t232 ) - rtP . R * t3 * t10 * t25 ) - rtP . R * t2 * t17 * ( t4 + 1.0 ) *
2.0 ) + rtP . R * t10 * t17 * ( t4 + 1.0 ) ) - rtP . L * rtP . R * t25 * rtP
. w ) + rtP . R * t2 * t15 * t21 * t30 * 2.0 ) - rtP . L * rtP . R * t15 *
t23 * t30 * rtP . w ) - rtP . R * 0.0 * t2 * t3 * t17 * 0.0 * 2.0 ) - rtP . R
* 0.0 * t2 * 0.0 * t25 * ( t4 + 1.0 ) * 2.0 ) + rtP . R * 0.0 * t10 * 0.0 *
t25 * ( t4 + 1.0 ) ) - rtP . R * t3 * t10 * t15 * t23 * t30 ) + rtP . R * t10
* t15 * t21 * t30 * ( t4 + 1.0 ) ) + rtP . R * t2 * t23 * t30 * t149 * t199 )
+ rtP . L * rtP . R * t3 * t15 * t21 * t30 * rtP . w * 2.0 ) + rtP . L * rtP
. R * t15 * t23 * t30 * ( t4 + 1.0 ) * rtP . w * 2.0 ) + rtP . L * rtP . R *
t21 * t30 * t149 * t199 * rtP . w * 0.5 ) - rtP . R * 0.0 * t2 * 0.0 * t15 *
t20 * t25 * 2.0 ) + rtP . R * 0.0 * t2 * 0.0 * t15 * t21 * t34 * 2.0 ) + rtP
. R * 0.0 * t2 * t15 * t23 * 0.0 * t30 * 2.0 ) + rtP . R * t3 * t10 * t21 *
t30 * t149 * t199 * 0.5 ) - rtP . R * t2 * t15 * t23 * t31 * t153 * t151 *
2.0 ) - rtP . L * rtP . R * 0.0 * 0.0 * t15 * t22 * t25 * rtP . w ) - rtP . L
* rtP . R * 0.0 * 0.0 * t15 * t23 * t34 * rtP . w ) + rtP . L * rtP . R * 0.0
* t15 * t21 * 0.0 * t30 * rtP . w ) + rtP . L * rtP . R * t3 * t23 * t30 *
t149 * t199 * rtP . w ) - rtP . L * rtP . R * t15 * t21 * t31 * t153 * t151 *
rtP . w ) - rtP . R * 0.0 * t3 * 0.0 * t10 * t15 * t22 * t25 ) - rtP . R *
0.0 * t3 * 0.0 * t10 * t15 * t23 * t34 ) + rtP . R * 0.0 * t3 * t10 * t15 *
t21 * 0.0 * t30 ) + rtP . R * 0.0 * 0.0 * t10 * t15 * t17 * t22 * ( t4 + 1.0
) ) + rtP . R * 0.0 * 0.0 * t10 * t15 * t21 * t34 * ( t4 + 1.0 ) ) + rtP . R
* 0.0 * t10 * t15 * t23 * 0.0 * t30 * ( t4 + 1.0 ) ) + rtP . R * 0.0 * t2 *
0.0 * t17 * t20 * t149 * t199 ) + rtP . R * 0.0 * t2 * 0.0 * t23 * t34 * t149
* t199 ) - rtP . R * 0.0 * t2 * t21 * 0.0 * t30 * t149 * t199 ) - rtP . R *
t3 * t10 * t15 * t21 * t31 * t153 * t151 ) - rtP . L * rtP . R * 0.0 * t3 *
0.0 * t15 * t20 * t25 * rtP . w * 2.0 ) + rtP . L * rtP . R * 0.0 * t3 * 0.0
* t15 * t21 * t34 * rtP . w * 2.0 ) + rtP . L * rtP . R * 0.0 * t3 * t15 *
t23 * 0.0 * t30 * rtP . w * 2.0 ) + rtP . L * rtP . R * 0.0 * 0.0 * t15 * t17
* t20 * ( t4 + 1.0 ) * rtP . w * 2.0 ) + rtP . L * rtP . R * 0.0 * 0.0 * t15
* t23 * t34 * ( t4 + 1.0 ) * rtP . w * 2.0 ) - rtP . L * rtP . R * 0.0 * t15
* t21 * 0.0 * t30 * ( t4 + 1.0 ) * rtP . w * 2.0 ) + rtP . L * rtP . R * 0.0
* 0.0 * t17 * t22 * t149 * t199 * rtP . w * 0.5 ) + rtP . L * rtP . R * 0.0 *
0.0 * t21 * t34 * t149 * t199 * rtP . w * 0.5 ) + rtP . L * rtP . R * 0.0 *
t23 * 0.0 * t30 * t149 * t199 * rtP . w * 0.5 ) - rtP . L * rtP . R * t3 *
t15 * t23 * t31 * t153 * t151 * rtP . w * 2.0 ) + rtP . R * 0.0 * 0.0 * t2 *
0.0 * t15 * t23 * 0.0 * t34 * 2.0 ) + rtP . R * 0.0 * t3 * 0.0 * t10 * t17 *
t22 * t149 * t199 * 0.5 ) + rtP . R * 0.0 * t3 * 0.0 * t10 * t21 * t34 * t149
* t199 * 0.5 ) + rtP . R * 0.0 * t3 * t10 * t23 * 0.0 * t30 * t149 * t199 *
0.5 ) + rtP . R * 0.0 * t2 * t15 * t21 * 0.0 * t31 * t153 * t151 * 2.0 ) +
rtP . L * rtP . R * 0.0 * 0.0 * 0.0 * t15 * t21 * 0.0 * t34 * rtP . w ) + rtP
. L * rtP . R * 0.0 * t3 * 0.0 * t17 * t20 * t149 * t199 * rtP . w ) + rtP .
L * rtP . R * 0.0 * t3 * 0.0 * t23 * t34 * t149 * t199 * rtP . w ) - rtP . L
* rtP . R * 0.0 * t3 * t21 * 0.0 * t30 * t149 * t199 * rtP . w ) - rtP . L *
rtP . R * 0.0 * t15 * t23 * 0.0 * t31 * t153 * t151 * rtP . w ) + rtP . R *
0.0 * 0.0 * t3 * 0.0 * t10 * t15 * t21 * 0.0 * t34 ) + rtP . R * 0.0 * 0.0 *
0.0 * t10 * t15 * t22 * 0.0 * t25 * ( t4 + 1.0 ) ) + rtP . R * 0.0 * 0.0 *
0.0 * t10 * t15 * t23 * 0.0 * t34 * ( t4 + 1.0 ) ) + rtP . R * 0.0 * 0.0 * t2
* 0.0 * t20 * 0.0 * t25 * t149 * t199 ) - rtP . R * 0.0 * 0.0 * t2 * 0.0 *
t21 * 0.0 * t34 * t149 * t199 ) - rtP . R * 0.0 * t3 * t10 * t15 * t23 * 0.0
* t31 * t153 * t151 ) + rtP . L * rtP . R * 0.0 * 0.0 * t3 * 0.0 * t15 * t23
* 0.0 * t34 * rtP . w * 2.0 ) + rtP . L * rtP . R * 0.0 * 0.0 * 0.0 * t15 *
t20 * 0.0 * t25 * ( t4 + 1.0 ) * rtP . w * 2.0 ) - rtP . L * rtP . R * 0.0 *
0.0 * 0.0 * t15 * t21 * 0.0 * t34 * ( t4 + 1.0 ) * rtP . w * 2.0 ) + rtP . L
* rtP . R * 0.0 * 0.0 * 0.0 * t22 * 0.0 * t25 * t149 * t199 * rtP . w * 0.5 )
+ rtP . L * rtP . R * 0.0 * 0.0 * 0.0 * t23 * 0.0 * t34 * t149 * t199 * rtP .
w * 0.5 ) + rtP . L * rtP . R * 0.0 * t3 * t15 * t21 * 0.0 * t31 * t153 *
t151 * rtP . w * 2.0 ) + rtP . R * 0.0 * 0.0 * t3 * 0.0 * t10 * t22 * 0.0 *
t25 * t149 * t199 * 0.5 ) + rtP . R * 0.0 * 0.0 * t3 * 0.0 * t10 * t23 * 0.0
* t34 * t149 * t199 * 0.5 ) + rtP . L * rtP . R * 0.0 * 0.0 * t3 * 0.0 * t20
* 0.0 * t25 * t149 * t199 * rtP . w ) - rtP . L * rtP . R * 0.0 * 0.0 * t3 *
0.0 * t21 * 0.0 * t34 * t149 * t199 * rtP . w ) * t123 - t148 * t139 * t18 )
* ehrq52oenb [ 3 ] + ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( rtP . R * 0.0 * t2 * t15
* t17 * t20 * 2.0 + rtP . R * 0.0 * t2 * t15 * t23 * t34 * 2.0 ) + rtP . L *
rtP . R * 0.0 * t15 * t17 * t22 * rtP . w ) + rtP . L * rtP . R * 0.0 * t15 *
t21 * t34 * rtP . w ) + rtP . R * 0.0 * t3 * t10 * t15 * t17 * t22 ) + rtP .
R * 0.0 * t3 * t10 * t15 * t21 * t34 ) + rtP . L * rtP . R * 0.0 * t3 * t15 *
t17 * t20 * rtP . w * 2.0 ) + rtP . L * rtP . R * 0.0 * t3 * t15 * t23 * t34
* rtP . w * 2.0 ) + rtP . R * 0.0 * 0.0 * t2 * t15 * t20 * 0.0 * t25 * 2.0 )
- rtP . R * 0.0 * 0.0 * t2 * t15 * t21 * 0.0 * t34 * 2.0 ) + rtP . L * rtP .
R * 0.0 * 0.0 * t15 * t22 * 0.0 * t25 * rtP . w ) + rtP . L * rtP . R * 0.0 *
0.0 * t15 * t23 * 0.0 * t34 * rtP . w ) + rtP . R * 0.0 * 0.0 * t3 * t10 *
t15 * t22 * 0.0 * t25 ) + rtP . R * 0.0 * 0.0 * t3 * t10 * t15 * t23 * 0.0 *
t34 ) + rtP . L * rtP . R * 0.0 * 0.0 * t3 * t15 * t20 * 0.0 * t25 * rtP . w
* 2.0 ) - rtP . L * rtP . R * 0.0 * 0.0 * t3 * t15 * t21 * 0.0 * t34 * rtP .
w * 2.0 ) * t123 - t148 * t139 * t200 ) * 0.0 ) + ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( rtP . R * t2 * 0.0 * t15 * t17 * t20 * 2.0 + rtP . R * t2 * 0.0 * t15 *
t23 * t34 * 2.0 ) + rtP . L * rtP . R * 0.0 * t15 * t17 * t22 * rtP . w ) +
rtP . L * rtP . R * 0.0 * t15 * t21 * t34 * rtP . w ) + rtP . R * t3 * 0.0 *
t10 * t15 * t17 * t22 ) + rtP . R * t3 * 0.0 * t10 * t15 * t21 * t34 ) + rtP
. L * rtP . R * t3 * 0.0 * t15 * t17 * t20 * rtP . w * 2.0 ) + rtP . L * rtP
. R * t3 * 0.0 * t15 * t23 * t34 * rtP . w * 2.0 ) + rtP . R * 0.0 * t2 * 0.0
* t15 * t20 * 0.0 * t25 * 2.0 ) - rtP . R * 0.0 * t2 * 0.0 * t15 * t21 * 0.0
* t34 * 2.0 ) + rtP . L * rtP . R * 0.0 * 0.0 * t15 * t22 * 0.0 * t25 * rtP .
w ) + rtP . L * rtP . R * 0.0 * 0.0 * t15 * t23 * 0.0 * t34 * rtP . w ) + rtP
. R * 0.0 * t3 * 0.0 * t10 * t15 * t22 * 0.0 * t25 ) + rtP . R * 0.0 * t3 *
0.0 * t10 * t15 * t23 * 0.0 * t34 ) + rtP . L * rtP . R * 0.0 * t3 * 0.0 *
t15 * t20 * 0.0 * t25 * rtP . w * 2.0 ) - rtP . L * rtP . R * 0.0 * t3 * 0.0
* t15 * t21 * 0.0 * t34 * rtP . w * 2.0 ) * t123 - t148 * t139 * t14 ) * 0.0
) + ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( rtP . L * rtP . R * 0.0 * t25 * rtP . w -
rtP . R * t2 * t3 * 0.0 * t25 * 2.0 ) + rtP . R * t3 * t10 * 0.0 * t25 ) -
rtP . R * t2 * t15 * t21 * 0.0 * t30 * 2.0 ) + rtP . L * rtP . R * t15 * t23
* 0.0 * t30 * rtP . w ) + rtP . R * t3 * t10 * t15 * t23 * 0.0 * t30 ) - rtP
. L * rtP . R * t3 * t15 * t21 * 0.0 * t30 * rtP . w * 2.0 ) + rtP . R * 0.0
* t2 * 0.0 * t15 * t20 * 0.0 * t25 * 2.0 ) - rtP . R * 0.0 * t2 * 0.0 * t15 *
t21 * 0.0 * t34 * 2.0 ) + rtP . L * rtP . R * 0.0 * 0.0 * t15 * t22 * 0.0 *
t25 * rtP . w ) + rtP . L * rtP . R * 0.0 * 0.0 * t15 * t23 * 0.0 * t34 * rtP
. w ) + rtP . R * 0.0 * t3 * 0.0 * t10 * t15 * t22 * 0.0 * t25 ) + rtP . R *
0.0 * t3 * 0.0 * t10 * t15 * t23 * 0.0 * t34 ) + rtP . L * rtP . R * 0.0 * t3
* 0.0 * t15 * t20 * 0.0 * t25 * rtP . w * 2.0 ) - rtP . L * rtP . R * 0.0 *
t3 * 0.0 * t15 * t21 * 0.0 * t34 * rtP . w * 2.0 ) * t123 - t148 * t139 * t26
) * 0.0 ) + ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( rtP . L * rtP . R * 0.0 * t25 * rtP
. w - rtP . R * 0.0 * t2 * t3 * t25 * 2.0 ) + rtP . R * 0.0 * t3 * t10 * t25
) - rtP . R * 0.0 * t2 * t15 * t21 * t30 * 2.0 ) + rtP . L * rtP . R * 0.0 *
t15 * t23 * t30 * rtP . w ) + rtP . R * 0.0 * t3 * t10 * t15 * t23 * t30 ) -
rtP . L * rtP . R * 0.0 * t3 * t15 * t21 * t30 * rtP . w * 2.0 ) + rtP . R *
0.0 * 0.0 * t2 * 0.0 * t15 * t20 * t25 * 2.0 ) - rtP . R * 0.0 * 0.0 * t2 *
0.0 * t15 * t21 * t34 * 2.0 ) + rtP . L * rtP . R * 0.0 * 0.0 * 0.0 * t15 *
t22 * t25 * rtP . w ) + rtP . L * rtP . R * 0.0 * 0.0 * 0.0 * t15 * t23 * t34
* rtP . w ) + rtP . R * 0.0 * 0.0 * t3 * 0.0 * t10 * t15 * t22 * t25 ) + rtP
. R * 0.0 * 0.0 * t3 * 0.0 * t10 * t15 * t23 * t34 ) + rtP . L * rtP . R *
0.0 * 0.0 * t3 * 0.0 * t15 * t20 * t25 * rtP . w * 2.0 ) - rtP . L * rtP . R
* 0.0 * 0.0 * t3 * 0.0 * t15 * t21 * t34 * rtP . w * 2.0 ) * t123 - t148 *
t139 * t341 ) * 0.0 ) ) + t123 * t194 * ehrq52oenb [ 2 ] ; mxorse3uag [ 10 ]
= ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( t124 + t125 ) + t129 ) + t130 ) + t132 ) + t134 ) + t136 ) + t140 )
+ t142 ) + t143 ) + t145 ) + t147 ) - t185 ) - t186 ) - rtP . R * t2 * t25 *
( t4 + 1.0 ) * 2.0 ) + rtP . R * t10 * t25 * ( t4 + 1.0 ) ) + rtP . R * t2 *
t15 * t21 * t31 * 2.0 ) - rtP . L * rtP . R * t15 * t23 * t31 * rtP . w ) +
rtP . R * 0.0 * t2 * t17 * 0.0 * ( t4 + 1.0 ) * 2.0 ) - rtP . R * 0.0 * t10 *
t17 * 0.0 * ( t4 + 1.0 ) ) - rtP . R * t3 * t10 * t15 * t23 * t31 ) + rtP . R
* t10 * t15 * t21 * t31 * ( t4 + 1.0 ) ) + rtP . R * t2 * t23 * t31 * t149 *
t199 ) + rtP . L * rtP . R * t3 * t15 * t21 * t31 * rtP . w * 2.0 ) + rtP . L
* rtP . R * t15 * t23 * t31 * ( t4 + 1.0 ) * rtP . w * 2.0 ) + rtP . L * rtP
. R * t21 * t31 * t149 * t199 * rtP . w * 0.5 ) - rtP . R * 0.0 * t2 * 0.0 *
t15 * t19 * t21 * 2.0 ) + rtP . R * 0.0 * t2 * t15 * t23 * 0.0 * t31 * 2.0 )
+ rtP . R * t3 * t10 * t21 * t31 * t149 * t199 * 0.5 ) + rtP . R * t2 * t15 *
t23 * t30 * t153 * t151 * 2.0 ) + rtP . L * rtP . R * 0.0 * 0.0 * t15 * t19 *
t23 * rtP . w ) + rtP . L * rtP . R * 0.0 * t15 * t21 * 0.0 * t31 * rtP . w )
+ rtP . L * rtP . R * t3 * t23 * t31 * t149 * t199 * rtP . w ) + rtP . L *
rtP . R * t15 * t21 * t30 * t153 * t151 * rtP . w ) + rtP . R * 0.0 * t3 *
0.0 * t10 * t15 * t19 * t23 ) + rtP . R * 0.0 * t3 * t10 * t15 * t21 * 0.0 *
t31 ) - rtP . R * 0.0 * 0.0 * t10 * t15 * t19 * t21 * ( t4 + 1.0 ) ) + rtP .
R * 0.0 * 0.0 * t10 * t15 * t22 * t25 * ( t4 + 1.0 ) ) + rtP . R * 0.0 * t10
* t15 * t23 * 0.0 * t31 * ( t4 + 1.0 ) ) - rtP . R * 0.0 * t2 * 0.0 * t19 *
t23 * t149 * t199 ) + rtP . R * 0.0 * t2 * 0.0 * t20 * t25 * t149 * t199 ) -
rtP . R * 0.0 * t2 * t21 * 0.0 * t31 * t149 * t199 ) + rtP . R * t3 * t10 *
t15 * t21 * t30 * t153 * t151 ) - rtP . L * rtP . R * 0.0 * t3 * 0.0 * t15 *
t19 * t21 * rtP . w * 2.0 ) + rtP . L * rtP . R * 0.0 * t3 * t15 * t23 * 0.0
* t31 * rtP . w * 2.0 ) - rtP . L * rtP . R * 0.0 * 0.0 * t15 * t19 * t23 * (
t4 + 1.0 ) * rtP . w * 2.0 ) + rtP . L * rtP . R * 0.0 * 0.0 * t15 * t20 *
t25 * ( t4 + 1.0 ) * rtP . w * 2.0 ) - rtP . L * rtP . R * 0.0 * t15 * t21 *
0.0 * t31 * ( t4 + 1.0 ) * rtP . w * 2.0 ) - rtP . L * rtP . R * 0.0 * 0.0 *
t19 * t21 * t149 * t199 * rtP . w * 0.5 ) + rtP . L * rtP . R * 0.0 * 0.0 *
t22 * t25 * t149 * t199 * rtP . w * 0.5 ) + rtP . L * rtP . R * 0.0 * t23 *
0.0 * t31 * t149 * t199 * rtP . w * 0.5 ) + rtP . L * rtP . R * t3 * t15 *
t23 * t30 * t153 * t151 * rtP . w * 2.0 ) - rtP . R * 0.0 * 0.0 * t2 * 0.0 *
t15 * t19 * t23 * 0.0 * 2.0 ) - rtP . R * 0.0 * t3 * 0.0 * t10 * t19 * t21 *
t149 * t199 * 0.5 ) + rtP . R * 0.0 * t3 * 0.0 * t10 * t22 * t25 * t149 *
t199 * 0.5 ) + rtP . R * 0.0 * t3 * t10 * t23 * 0.0 * t31 * t149 * t199 * 0.5
) - rtP . R * 0.0 * t2 * t15 * t21 * 0.0 * t30 * t153 * t151 * 2.0 ) - rtP .
L * rtP . R * 0.0 * 0.0 * 0.0 * t15 * t19 * t21 * 0.0 * rtP . w ) - rtP . L *
rtP . R * 0.0 * t3 * 0.0 * t19 * t23 * t149 * t199 * rtP . w ) + rtP . L *
rtP . R * 0.0 * t3 * 0.0 * t20 * t25 * t149 * t199 * rtP . w ) - rtP . L *
rtP . R * 0.0 * t3 * t21 * 0.0 * t31 * t149 * t199 * rtP . w ) + rtP . L *
rtP . R * 0.0 * t15 * t23 * 0.0 * t30 * t153 * t151 * rtP . w ) - rtP . R *
0.0 * 0.0 * t3 * 0.0 * t10 * t15 * t19 * t21 * 0.0 ) - rtP . R * 0.0 * 0.0 *
0.0 * t10 * t15 * t17 * t22 * 0.0 * ( t4 + 1.0 ) ) - rtP . R * 0.0 * 0.0 *
0.0 * t10 * t15 * t19 * t23 * 0.0 * ( t4 + 1.0 ) ) - rtP . R * 0.0 * 0.0 * t2
* 0.0 * t17 * t20 * 0.0 * t149 * t199 ) + rtP . R * 0.0 * 0.0 * t2 * 0.0 *
t19 * t21 * 0.0 * t149 * t199 ) + rtP . R * 0.0 * t3 * t10 * t15 * t23 * 0.0
* t30 * t153 * t151 ) - rtP . L * rtP . R * 0.0 * 0.0 * t3 * 0.0 * t15 * t19
* t23 * 0.0 * rtP . w * 2.0 ) - rtP . L * rtP . R * 0.0 * 0.0 * 0.0 * t15 *
t17 * t20 * 0.0 * ( t4 + 1.0 ) * rtP . w * 2.0 ) + rtP . L * rtP . R * 0.0 *
0.0 * 0.0 * t15 * t19 * t21 * 0.0 * ( t4 + 1.0 ) * rtP . w * 2.0 ) - rtP . L
* rtP . R * 0.0 * 0.0 * 0.0 * t17 * t22 * 0.0 * t149 * t199 * rtP . w * 0.5 )
- rtP . L * rtP . R * 0.0 * 0.0 * 0.0 * t19 * t23 * 0.0 * t149 * t199 * rtP .
w * 0.5 ) - rtP . L * rtP . R * 0.0 * t3 * t15 * t21 * 0.0 * t30 * t153 *
t151 * rtP . w * 2.0 ) - rtP . R * 0.0 * 0.0 * t3 * 0.0 * t10 * t17 * t22 *
0.0 * t149 * t199 * 0.5 ) - rtP . R * 0.0 * 0.0 * t3 * 0.0 * t10 * t19 * t23
* 0.0 * t149 * t199 * 0.5 ) - rtP . L * rtP . R * 0.0 * 0.0 * t3 * 0.0 * t17
* t20 * 0.0 * t149 * t199 * rtP . w ) + rtP . L * rtP . R * 0.0 * 0.0 * t3 *
0.0 * t19 * t21 * 0.0 * t149 * t199 * rtP . w ) * t123 + ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( t220 + t221 ) + t222 ) + t223 ) + t224
) + t225 ) + t226 ) + t227 ) + t228 ) + t160 ) + t230 ) + t231 ) + t232 ) +
t233 ) + t234 ) - t290 ) - t291 ) - t292 ) - t293 ) - t294 ) - t295 ) - t296
) - t297 ) - t298 ) - t299 ) - t300 ) - t301 ) - t302 ) - t303 ) - t304 ) * (
t139 * t18 ) ) * ehrq52oenb [ 3 ] + ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( t220 + t221 ) + t222 ) + t223 ) + t224 ) + t225 ) + t226
) + t227 ) + t228 ) + t160 ) + t230 ) + t231 ) + t232 ) + t233 ) + t234 ) -
t290 ) - t291 ) - t292 ) - t293 ) - t294 ) - t295 ) - t296 ) - t297 ) - t298
) - t299 ) - t300 ) - t301 ) - t302 ) - t303 ) - t304 ) * ( t139 * t28 ) + (
( ( ( ( ( ( ( ( ( ( ( ( ( ( t133 + t135 ) + t137 ) + t141 ) + t144 ) + t146 )
- t127 ) - t131 ) - rtP . R * 0.0 * t2 * 0.0 * t15 * t22 * t25 * 2.0 ) + rtP
. L * rtP . R * 0.0 * 0.0 * t15 * t20 * t25 * rtP . w ) + rtP . R * 0.0 * t3
* 0.0 * t10 * t15 * t20 * t25 ) - rtP . L * rtP . R * 0.0 * t3 * 0.0 * t15 *
t22 * t25 * rtP . w * 2.0 ) + rtP . R * 0.0 * 0.0 * t2 * 0.0 * t15 * t17 *
t22 * 0.0 * 2.0 ) - rtP . L * rtP . R * 0.0 * 0.0 * 0.0 * t15 * t17 * t20 *
0.0 * rtP . w ) - rtP . R * 0.0 * 0.0 * t3 * 0.0 * t10 * t15 * t17 * t20 *
0.0 ) + rtP . L * rtP . R * 0.0 * 0.0 * t3 * 0.0 * t15 * t17 * t22 * 0.0 *
rtP . w * 2.0 ) * t123 ) * rtB . hkbmt1bwgv [ 9 ] - ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( rtP . R * 0.0 * t2 * t15 * t19 * t23 * 2.0 - rtP . R * 0.0 * t2 * t15 *
t20 * t25 * 2.0 ) + rtP . L * rtP . R * 0.0 * t15 * t19 * t21 * rtP . w ) -
rtP . L * rtP . R * 0.0 * t15 * t22 * t25 * rtP . w ) + rtP . R * 0.0 * t3 *
t10 * t15 * t19 * t21 ) - rtP . R * 0.0 * t3 * t10 * t15 * t22 * t25 ) + rtP
. L * rtP . R * 0.0 * t3 * t15 * t19 * t23 * rtP . w * 2.0 ) - rtP . L * rtP
. R * 0.0 * t3 * t15 * t20 * t25 * rtP . w * 2.0 ) + rtP . R * 0.0 * 0.0 * t2
* t15 * t17 * t20 * 0.0 * 2.0 ) - rtP . R * 0.0 * 0.0 * t2 * t15 * t19 * t21
* 0.0 * 2.0 ) + rtP . L * rtP . R * 0.0 * 0.0 * t15 * t17 * t22 * 0.0 * rtP .
w ) + rtP . L * rtP . R * 0.0 * 0.0 * t15 * t19 * t23 * 0.0 * rtP . w ) + rtP
. R * 0.0 * 0.0 * t3 * t10 * t15 * t17 * t22 * 0.0 ) + rtP . R * 0.0 * 0.0 *
t3 * t10 * t15 * t19 * t23 * 0.0 ) + rtP . L * rtP . R * 0.0 * 0.0 * t3 * t15
* t17 * t20 * 0.0 * rtP . w * 2.0 ) - rtP . L * rtP . R * 0.0 * 0.0 * t3 *
t15 * t19 * t21 * 0.0 * rtP . w * 2.0 ) * t123 - t139 * t194 * t200 ) * 0.0 )
) - ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( rtP . R * t2 * 0.0 * t15 * t19 * t23 *
2.0 - rtP . R * t2 * 0.0 * t15 * t20 * t25 * 2.0 ) + rtP . L * rtP . R * 0.0
* t15 * t19 * t21 * rtP . w ) - rtP . L * rtP . R * 0.0 * t15 * t22 * t25 *
rtP . w ) + rtP . R * t3 * 0.0 * t10 * t15 * t19 * t21 ) - rtP . R * t3 * 0.0
* t10 * t15 * t22 * t25 ) + rtP . L * rtP . R * t3 * 0.0 * t15 * t19 * t23 *
rtP . w * 2.0 ) - rtP . L * rtP . R * t3 * 0.0 * t15 * t20 * t25 * rtP . w *
2.0 ) + rtP . R * 0.0 * t2 * 0.0 * t15 * t17 * t20 * 0.0 * 2.0 ) - rtP . R *
0.0 * t2 * 0.0 * t15 * t19 * t21 * 0.0 * 2.0 ) + rtP . L * rtP . R * 0.0 *
0.0 * t15 * t17 * t22 * 0.0 * rtP . w ) + rtP . L * rtP . R * 0.0 * 0.0 * t15
* t19 * t23 * 0.0 * rtP . w ) + rtP . R * 0.0 * t3 * 0.0 * t10 * t15 * t17 *
t22 * 0.0 ) + rtP . R * 0.0 * t3 * 0.0 * t10 * t15 * t19 * t23 * 0.0 ) + rtP
. L * rtP . R * 0.0 * t3 * 0.0 * t15 * t17 * t20 * 0.0 * rtP . w * 2.0 ) -
rtP . L * rtP . R * 0.0 * t3 * 0.0 * t15 * t19 * t21 * 0.0 * rtP . w * 2.0 )
* t123 - t139 * t14 * t194 ) * 0.0 ) - ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( rtP . L
* rtP . R * t17 * 0.0 * rtP . w - rtP . R * t2 * t3 * t17 * 0.0 * 2.0 ) + rtP
. R * t3 * t10 * t17 * 0.0 ) + rtP . R * t2 * t15 * t21 * 0.0 * t31 * 2.0 ) -
rtP . L * rtP . R * t15 * t23 * 0.0 * t31 * rtP . w ) - rtP . R * t3 * t10 *
t15 * t23 * 0.0 * t31 ) + rtP . L * rtP . R * t3 * t15 * t21 * 0.0 * t31 *
rtP . w * 2.0 ) + rtP . R * 0.0 * t2 * 0.0 * t15 * t17 * t20 * 0.0 * 2.0 ) -
rtP . R * 0.0 * t2 * 0.0 * t15 * t19 * t21 * 0.0 * 2.0 ) + rtP . L * rtP . R
* 0.0 * 0.0 * t15 * t17 * t22 * 0.0 * rtP . w ) + rtP . L * rtP . R * 0.0 *
0.0 * t15 * t19 * t23 * 0.0 * rtP . w ) + rtP . R * 0.0 * t3 * 0.0 * t10 *
t15 * t17 * t22 * 0.0 ) + rtP . R * 0.0 * t3 * 0.0 * t10 * t15 * t19 * t23 *
0.0 ) + rtP . L * rtP . R * 0.0 * t3 * 0.0 * t15 * t17 * t20 * 0.0 * rtP . w
* 2.0 ) - rtP . L * rtP . R * 0.0 * t3 * 0.0 * t15 * t19 * t21 * 0.0 * rtP .
w * 2.0 ) * t123 - t139 * t194 * t26 ) * 0.0 ) - ( ( ( ( ( ( ( ( ( ( ( ( ( (
( rtP . L * rtP . R * 0.0 * t17 * rtP . w - rtP . R * 0.0 * t2 * t3 * t17 *
2.0 ) + rtP . R * 0.0 * t3 * t10 * t17 ) + rtP . R * 0.0 * t2 * t15 * t21 *
t31 * 2.0 ) - rtP . L * rtP . R * 0.0 * t15 * t23 * t31 * rtP . w ) - rtP . R
* 0.0 * t3 * t10 * t15 * t23 * t31 ) + rtP . L * rtP . R * 0.0 * t3 * t15 *
t21 * t31 * rtP . w * 2.0 ) + rtP . R * 0.0 * 0.0 * t2 * 0.0 * t15 * t17 *
t20 * 2.0 ) - rtP . R * 0.0 * 0.0 * t2 * 0.0 * t15 * t19 * t21 * 2.0 ) + rtP
. L * rtP . R * 0.0 * 0.0 * 0.0 * t15 * t17 * t22 * rtP . w ) + rtP . L * rtP
. R * 0.0 * 0.0 * 0.0 * t15 * t19 * t23 * rtP . w ) + rtP . R * 0.0 * 0.0 *
t3 * 0.0 * t10 * t15 * t17 * t22 ) + rtP . R * 0.0 * 0.0 * t3 * 0.0 * t10 *
t15 * t19 * t23 ) + rtP . L * rtP . R * 0.0 * 0.0 * t3 * 0.0 * t15 * t17 *
t20 * rtP . w * 2.0 ) - rtP . L * rtP . R * 0.0 * 0.0 * t3 * 0.0 * t15 * t19
* t21 * rtP . w * 2.0 ) * t123 - t139 * t194 * t341 ) * 0.0 ) + t148 * t123 *
ehrq52oenb [ 2 ] ; mxorse3uag [ 11 ] = ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( t27 +
t12 ) + t170 ) + t17 * t30 ) + t25 * t31 ) - 0.0 * t19 * t25 ) - 0.0 * t17 *
0.0 * t31 ) + 0.0 * t25 * t30 ) - t17 * t30 * t153 * t151 ) - t25 * t31 *
t153 * t151 ) + 0.0 * t17 * 0.0 * t31 * t153 * t151 ) - 0.0 * t25 * t30 *
t153 * t151 ) * ( rtP . R * t7 * t15 * t123 ) * 2.0 - rtP . R * t7 * t123 *
t149 * t199 * t29 ) + rtP . R * t7 * t15 * t139 * t18 * t29 * 2.0 ) - rtP . R
* t15 * t123 * ( t4 + 1.0 ) * t29 * rtP . w * 2.0 ) * ehrq52oenb [ 3 ] + ( (
( ( ( ( 0.0 * t17 * t19 + 0.0 * t25 * t34 ) + 0.0 * t19 * 0.0 * t25 ) - 0.0 *
t17 * 0.0 * t34 ) * ( rtP . R * t7 * t15 * t123 ) * 2.0 + rtP . R * t7 * t15
* t139 * t14 * t29 * 2.0 ) * 0.0 + ( rtP . R * t7 * t15 * t123 * ( ( ( t27 +
t12 ) + t170 ) - 0.0 * t19 * t25 ) * 2.0 - rtP . R * t7 * t15 * t139 * t28 *
t29 * 2.0 ) * - rtB . hkbmt1bwgv [ 9 ] ) - ( ( ( ( t17 * 0.0 * t30 + 0.0 *
t25 * t31 ) - 0.0 * t19 * 0.0 * t25 ) + 0.0 * t17 * 0.0 * t34 ) * ( rtP . R *
t7 * t15 * t123 ) * 2.0 - rtP . R * t7 * t15 * t139 * t26 * t29 * 2.0 ) * 0.0
) ) + ( ( ( ( 0.0 * t17 * t19 + 0.0 * t25 * t34 ) + 0.0 * t19 * 0.0 * t25 ) -
0.0 * t17 * 0.0 * t34 ) * ( rtP . R * t7 * t15 * t123 ) * 2.0 + rtP . R * t7
* t15 * t139 * t200 * t29 * 2.0 ) * 0.0 ) - ( ( ( ( 0.0 * t17 * t30 + 0.0 *
t25 * t31 ) - 0.0 * t19 * t25 ) + 0.0 * t17 * t34 ) * ( rtP . R * t7 * t15 *
t123 ) * 2.0 - rtP . R * t7 * t15 * t139 * t341 * t29 * 2.0 ) * 0.0 ;
mxorse3uag [ 12 ] = 0.0 ; mxorse3uag [ 13 ] = 0.0 ; mxorse3uag [ 14 ] = ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( t4 + 1.0 ) * t2 * t174 * - 2.0 - ( t4 + 1.0 ) * t2 * t175 * 2.0 ) + (
t4 + 1.0 ) * t10 * t174 ) + ( t4 + 1.0 ) * t10 * t175 ) + t10 * t15 * t17 *
t21 * t30 * ( t4 + 1.0 ) ) - t10 * t15 * t17 * t23 * t31 * ( t4 + 1.0 ) ) +
t10 * t15 * t21 * t25 * t31 * ( t4 + 1.0 ) ) + t10 * t15 * t23 * t25 * t30 *
( t4 + 1.0 ) ) + t2 * t17 * t21 * t31 * t149 * t199 ) + t2 * t17 * t23 * t30
* t149 * t199 ) - t2 * t21 * t25 * t30 * t149 * t199 ) + t2 * t23 * t25 * t31
* t149 * t199 ) + rtP . L * t15 * t17 * t21 * t31 * ( t4 + 1.0 ) * rtP . w *
2.0 ) + rtP . L * t15 * t17 * t23 * t30 * ( t4 + 1.0 ) * rtP . w * 2.0 ) -
rtP . L * t15 * t21 * t25 * t30 * ( t4 + 1.0 ) * rtP . w * 2.0 ) + rtP . L *
t15 * t23 * t25 * t31 * ( t4 + 1.0 ) * rtP . w * 2.0 ) + rtP . L * t17 * t21
* t30 * t149 * t199 * rtP . w * 0.5 ) - rtP . L * t17 * t23 * t31 * t149 *
t199 * rtP . w * 0.5 ) + rtP . L * t21 * t25 * t31 * t149 * t199 * rtP . w *
0.5 ) + rtP . L * t23 * t25 * t30 * t149 * t199 * rtP . w * 0.5 ) + 0.0 * t10
* t15 * t22 * ( t4 + 1.0 ) * t174 ) + 0.0 * t10 * t15 * t22 * ( t4 + 1.0 ) *
t175 ) + 0.0 * t2 * 0.0 * t20 * t149 * t199 * t174 ) + 0.0 * t2 * 0.0 * t20 *
t149 * t199 * t175 ) + t3 * t10 * t17 * t21 * t30 * t149 * t199 * 0.5 ) - t3
* t10 * t17 * t23 * t31 * t149 * t199 * 0.5 ) + t3 * t10 * t21 * t25 * t31 *
t149 * t199 * 0.5 ) + t3 * t10 * t23 * t25 * t30 * t149 * t199 * 0.5 ) + t2 *
t15 * t17 * t21 * t30 * t153 * t151 * 2.0 ) - t2 * t15 * t17 * t23 * t31 *
t153 * t151 * 2.0 ) + t2 * t15 * t21 * t25 * t31 * t153 * t151 * 2.0 ) + t2 *
t15 * t23 * t25 * t30 * t153 * t151 * 2.0 ) + rtP . L * 0.0 * 0.0 * t15 * t20
* ( t4 + 1.0 ) * t174 * rtP . w * 2.0 ) + rtP . L * 0.0 * 0.0 * t15 * t20 * (
t4 + 1.0 ) * t175 * rtP . w * 2.0 ) + rtP . L * 0.0 * 0.0 * t22 * t149 * t199
* t174 * rtP . w * 0.5 ) + rtP . L * 0.0 * 0.0 * t22 * t149 * t199 * t175 *
rtP . w * 0.5 ) + rtP . L * t3 * t17 * t21 * t31 * t149 * t199 * rtP . w ) +
rtP . L * t3 * t17 * t23 * t30 * t149 * t199 * rtP . w ) - rtP . L * t3 * t21
* t25 * t30 * t149 * t199 * rtP . w ) + rtP . L * t3 * t23 * t25 * t31 * t149
* t199 * rtP . w ) - rtP . L * t15 * t17 * t21 * t31 * t153 * t151 * rtP . w
) - rtP . L * t15 * t17 * t23 * t30 * t153 * t151 * rtP . w ) + rtP . L * t15
* t21 * t25 * t30 * t153 * t151 * rtP . w ) - rtP . L * t15 * t23 * t25 * t31
* t153 * t151 * rtP . w ) + 0.0 * t10 * t15 * t17 * t19 * t23 * ( t4 + 1.0 )
) - 0.0 * t10 * t15 * t19 * t21 * t25 * ( t4 + 1.0 ) ) + 0.0 * t10 * t15 *
t17 * t21 * t34 * ( t4 + 1.0 ) ) + 0.0 * t10 * t15 * t23 * t25 * t34 * ( t4 +
1.0 ) ) - 0.0 * t2 * 0.0 * t17 * t19 * t21 * t149 * t199 ) - 0.0 * t2 * 0.0 *
t19 * t23 * t25 * t149 * t199 ) + 0.0 * t2 * 0.0 * t17 * t23 * t34 * t149 *
t199 ) - 0.0 * t2 * 0.0 * t21 * t25 * t34 * t149 * t199 ) + 0.0 * t3 * 0.0 *
t10 * t22 * t149 * t199 * t174 * 0.5 ) + 0.0 * t3 * 0.0 * t10 * t22 * t149 *
t199 * t175 * 0.5 ) - t3 * t10 * t15 * t17 * t21 * t31 * t153 * t151 ) - t3 *
t10 * t15 * t17 * t23 * t30 * t153 * t151 ) + t3 * t10 * t15 * t21 * t25 *
t30 * t153 * t151 ) - t3 * t10 * t15 * t23 * t25 * t31 * t153 * t151 ) - rtP
. L * 0.0 * 0.0 * t15 * t17 * t19 * t21 * ( t4 + 1.0 ) * rtP . w * 2.0 ) -
rtP . L * 0.0 * 0.0 * t15 * t19 * t23 * t25 * ( t4 + 1.0 ) * rtP . w * 2.0 )
+ rtP . L * 0.0 * 0.0 * t15 * t17 * t23 * t34 * ( t4 + 1.0 ) * rtP . w * 2.0
) - rtP . L * 0.0 * 0.0 * t15 * t21 * t25 * t34 * ( t4 + 1.0 ) * rtP . w *
2.0 ) + rtP . L * 0.0 * 0.0 * t17 * t19 * t23 * t149 * t199 * rtP . w * 0.5 )
- rtP . L * 0.0 * 0.0 * t19 * t21 * t25 * t149 * t199 * rtP . w * 0.5 ) + rtP
. L * 0.0 * 0.0 * t17 * t21 * t34 * t149 * t199 * rtP . w * 0.5 ) + rtP . L *
0.0 * 0.0 * t23 * t25 * t34 * t149 * t199 * rtP . w * 0.5 ) + rtP . L * 0.0 *
t3 * 0.0 * t20 * t149 * t199 * t174 * rtP . w ) + rtP . L * 0.0 * t3 * 0.0 *
t20 * t149 * t199 * t175 * rtP . w ) + rtP . L * t3 * t15 * t17 * t21 * t30 *
t153 * t151 * rtP . w * 2.0 ) - rtP . L * t3 * t15 * t17 * t23 * t31 * t153 *
t151 * rtP . w * 2.0 ) + rtP . L * t3 * t15 * t21 * t25 * t31 * t153 * t151 *
rtP . w * 2.0 ) + rtP . L * t3 * t15 * t23 * t25 * t30 * t153 * t151 * rtP .
w * 2.0 ) + 0.0 * t3 * 0.0 * t10 * t17 * t19 * t23 * t149 * t199 * 0.5 ) -
0.0 * t3 * 0.0 * t10 * t19 * t21 * t25 * t149 * t199 * 0.5 ) + 0.0 * t3 * 0.0
* t10 * t17 * t21 * t34 * t149 * t199 * 0.5 ) + 0.0 * t3 * 0.0 * t10 * t23 *
t25 * t34 * t149 * t199 * 0.5 ) - rtP . L * 0.0 * t3 * 0.0 * t17 * t19 * t21
* t149 * t199 * rtP . w ) - rtP . L * 0.0 * t3 * 0.0 * t19 * t23 * t25 * t149
* t199 * rtP . w ) + rtP . L * 0.0 * t3 * 0.0 * t17 * t23 * t34 * t149 * t199
* rtP . w ) - rtP . L * 0.0 * t3 * 0.0 * t21 * t25 * t34 * t149 * t199 * rtP
. w ) * t123 - t139 * t18 * t178 ) * ehrq52oenb [ 3 ] + ( ( 0.0 * t123 * t178
- t139 * t26 * t178 ) * 0.0 + ( 0.0 * t123 * t178 - t139 * t341 * t178 ) *
0.0 ) ) + ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( t2 * 0.0 * t15 *
t20 * t174 * 2.0 + t2 * 0.0 * t15 * t20 * t175 * 2.0 ) - t2 * 0.0 * t15 * t17
* t19 * t21 * 2.0 ) - t2 * 0.0 * t15 * t19 * t23 * t25 * 2.0 ) + t2 * 0.0 *
t15 * t17 * t23 * t34 * 2.0 ) - t2 * 0.0 * t15 * t21 * t25 * t34 * 2.0 ) + t3
* 0.0 * t10 * t15 * t22 * t174 ) + t3 * 0.0 * t10 * t15 * t22 * t175 ) + rtP
. L * 0.0 * t15 * t22 * t174 * rtP . w ) + rtP . L * 0.0 * t15 * t22 * t175 *
rtP . w ) + rtP . L * 0.0 * t15 * t17 * t19 * t23 * rtP . w ) - rtP . L * 0.0
* t15 * t19 * t21 * t25 * rtP . w ) + rtP . L * 0.0 * t15 * t17 * t21 * t34 *
rtP . w ) + rtP . L * 0.0 * t15 * t23 * t25 * t34 * rtP . w ) + rtP . L * t3
* 0.0 * t15 * t20 * t174 * rtP . w * 2.0 ) + rtP . L * t3 * 0.0 * t15 * t20 *
t175 * rtP . w * 2.0 ) + t3 * 0.0 * t10 * t15 * t17 * t19 * t23 ) - t3 * 0.0
* t10 * t15 * t19 * t21 * t25 ) + t3 * 0.0 * t10 * t15 * t17 * t21 * t34 ) +
t3 * 0.0 * t10 * t15 * t23 * t25 * t34 ) - rtP . L * t3 * 0.0 * t15 * t17 *
t19 * t21 * rtP . w * 2.0 ) - rtP . L * t3 * 0.0 * t15 * t19 * t23 * t25 *
rtP . w * 2.0 ) + rtP . L * t3 * 0.0 * t15 * t17 * t23 * t34 * rtP . w * 2.0
) - rtP . L * t3 * 0.0 * t15 * t21 * t25 * t34 * rtP . w * 2.0 ) * t123 -
t139 * t14 * t178 ) * 0.0 ) + ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
0.0 * t2 * t15 * t20 * t174 * 2.0 + 0.0 * t2 * t15 * t20 * t175 * 2.0 ) + rtP
. L * 0.0 * t15 * t22 * t174 * rtP . w ) + rtP . L * 0.0 * t15 * t22 * t175 *
rtP . w ) - 0.0 * t2 * t15 * t17 * t19 * t21 * 2.0 ) - 0.0 * t2 * t15 * t19 *
t23 * t25 * 2.0 ) + 0.0 * t2 * t15 * t17 * t23 * t34 * 2.0 ) - 0.0 * t2 * t15
* t21 * t25 * t34 * 2.0 ) + 0.0 * t3 * t10 * t15 * t22 * t174 ) + 0.0 * t3 *
t10 * t15 * t22 * t175 ) + rtP . L * 0.0 * t15 * t17 * t19 * t23 * rtP . w )
- rtP . L * 0.0 * t15 * t19 * t21 * t25 * rtP . w ) + rtP . L * 0.0 * t15 *
t17 * t21 * t34 * rtP . w ) + rtP . L * 0.0 * t15 * t23 * t25 * t34 * rtP . w
) + rtP . L * 0.0 * t3 * t15 * t20 * t174 * rtP . w * 2.0 ) + rtP . L * 0.0 *
t3 * t15 * t20 * t175 * rtP . w * 2.0 ) + 0.0 * t3 * t10 * t15 * t17 * t19 *
t23 ) - 0.0 * t3 * t10 * t15 * t19 * t21 * t25 ) + 0.0 * t3 * t10 * t15 * t17
* t21 * t34 ) + 0.0 * t3 * t10 * t15 * t23 * t25 * t34 ) - rtP . L * 0.0 * t3
* t15 * t17 * t19 * t21 * rtP . w * 2.0 ) - rtP . L * 0.0 * t3 * t15 * t19 *
t23 * t25 * rtP . w * 2.0 ) + rtP . L * 0.0 * t3 * t15 * t17 * t23 * t34 *
rtP . w * 2.0 ) - rtP . L * 0.0 * t3 * t15 * t21 * t25 * t34 * rtP . w * 2.0
) * t123 - t139 * t200 * t178 ) * 0.0 ) + ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( 0.0 * t2 * 0.0 * t15 * t22 * t174 * - 2.0 - 0.0 * t2 * 0.0 * t15
* t22 * t175 * 2.0 ) + rtP . L * 0.0 * 0.0 * t15 * t20 * t174 * rtP . w ) +
rtP . L * 0.0 * 0.0 * t15 * t20 * t175 * rtP . w ) + 0.0 * t2 * 0.0 * t15 *
t17 * t19 * t23 * 2.0 ) - 0.0 * t2 * 0.0 * t15 * t19 * t21 * t25 * 2.0 ) +
0.0 * t2 * 0.0 * t15 * t17 * t21 * t34 * 2.0 ) + 0.0 * t2 * 0.0 * t15 * t23 *
t25 * t34 * 2.0 ) + 0.0 * t3 * 0.0 * t10 * t15 * t20 * t174 ) + 0.0 * t3 *
0.0 * t10 * t15 * t20 * t175 ) + rtP . L * 0.0 * 0.0 * t15 * t17 * t19 * t21
* rtP . w ) + rtP . L * 0.0 * 0.0 * t15 * t19 * t23 * t25 * rtP . w ) - rtP .
L * 0.0 * 0.0 * t15 * t17 * t23 * t34 * rtP . w ) + rtP . L * 0.0 * 0.0 * t15
* t21 * t25 * t34 * rtP . w ) - rtP . L * 0.0 * t3 * 0.0 * t15 * t22 * t174 *
rtP . w * 2.0 ) - rtP . L * 0.0 * t3 * 0.0 * t15 * t22 * t175 * rtP . w * 2.0
) + 0.0 * t3 * 0.0 * t10 * t15 * t17 * t19 * t21 ) + 0.0 * t3 * 0.0 * t10 *
t15 * t19 * t23 * t25 ) - 0.0 * t3 * 0.0 * t10 * t15 * t17 * t23 * t34 ) +
0.0 * t3 * 0.0 * t10 * t15 * t21 * t25 * t34 ) + rtP . L * 0.0 * t3 * 0.0 *
t15 * t17 * t19 * t23 * rtP . w * 2.0 ) - rtP . L * 0.0 * t3 * 0.0 * t15 *
t19 * t21 * t25 * rtP . w * 2.0 ) + rtP . L * 0.0 * t3 * 0.0 * t15 * t17 *
t21 * t34 * rtP . w * 2.0 ) + rtP . L * 0.0 * t3 * 0.0 * t15 * t23 * t25 *
t34 * rtP . w * 2.0 ) * t123 - t139 * t28 * t178 ) * rtB . hkbmt1bwgv [ 9 ] ;
memset ( & mxorse3uag [ 15 ] , 0 , 10U * sizeof ( real_T ) ) ; mxorse3uag [
25 ] = - rtP . L * ehrq52oenb [ 3 ] * t8 * ( t4 + 1.0 ) * rtP . w ;
mxorse3uag [ 26 ] = 0.0 ; for ( p1 = 0 ; p1 < 9 ; p1 ++ ) { rtB . m2wc2u3tke
[ p1 ] = 0.0 ; rtB . m2wc2u3tke [ p1 ] += nn5hyolh34 [ p1 ] * rtB .
hkbmt1bwgv [ 9 ] ; rtB . m2wc2u3tke [ p1 ] += nn5hyolh34 [ p1 + 9 ] * rtB .
hkbmt1bwgv [ 10 ] ; rtB . m2wc2u3tke [ p1 ] += nn5hyolh34 [ p1 + 18 ] * rtB .
hkbmt1bwgv [ 11 ] ; } t2 = muDoubleScalarSin ( rtB . hkbmt1bwgv [ 2 ] ) ; t3
= muDoubleScalarCos ( rtB . hkbmt1bwgv [ 2 ] ) ; t4 = ( ( ( rtP . mc + rtP .
mi ) + rtP . ml ) + rtP . mo ) + rtP . mr ; t7 = ( ( ( ( ( rtP . mo * t2 *
rtP . w * 0.5 + rtP . mr * t2 * rtP . w * 0.5 ) - rtP . L * rtP . mi * t3 ) -
rtP . L * rtP . mo * t3 ) - rtP . Lc * rtP . mc * t3 ) - rtP . mi * t2 * rtP
. w * 0.5 ) - rtP . ml * t2 * rtP . w * 0.5 ; t10 = ( ( ( ( ( rtP . mi * t3 *
rtP . w * 0.5 + rtP . ml * t3 * rtP . w * 0.5 ) - rtP . L * rtP . mi * t2 ) -
rtP . L * rtP . mo * t2 ) - rtP . Lc * rtP . mc * t2 ) - rtP . mo * t3 * rtP
. w * 0.5 ) - rtP . mr * t3 * rtP . w * 0.5 ; t11 = muDoubleScalarCos ( rtB .
hkbmt1bwgv [ 5 ] ) ; t12 = t11 * t11 ; t13 = muDoubleScalarCos ( rtB .
hkbmt1bwgv [ 6 ] ) ; t14 = t13 * t13 ; t15 = muDoubleScalarCos ( rtB .
hkbmt1bwgv [ 7 ] ) ; t16 = t15 * t15 ; t17 = muDoubleScalarCos ( rtB .
hkbmt1bwgv [ 8 ] ) ; t18 = t17 * t17 ; t19 = muDoubleScalarSin ( rtB .
hkbmt1bwgv [ 6 ] ) ; t20 = t19 * t19 ; t21 = t3 * t3 ; t22 =
muDoubleScalarSin ( rtB . hkbmt1bwgv [ 8 ] ) ; t23 = t22 * t22 ; t24 = t2 *
t2 ; t25 = rtP . L * rtP . L ; t26 = rtP . Lc * rtP . Lc ; t27 = rtP . w *
rtP . w ; t30 = muDoubleScalarCos ( rtB . hkbmt1bwgv [ 3 ] ) ; t31 =
muDoubleScalarSin ( rtB . hkbmt1bwgv [ 5 ] ) ; t32 = t31 * t31 ; t33 =
muDoubleScalarCos ( rtB . hkbmt1bwgv [ 4 ] ) ; t34 = muDoubleScalarSin ( rtB
. hkbmt1bwgv [ 7 ] ) ; t35 = t34 * t34 ; t36 = t30 * t30 ; t37 =
muDoubleScalarSin ( rtB . hkbmt1bwgv [ 3 ] ) ; t38 = t33 * t33 ; t9 =
muDoubleScalarSin ( rtB . hkbmt1bwgv [ 4 ] ) ; t40 = t37 * t37 ; t41 = t32 *
t32 ; t42 = t9 * t9 ; t43 = t35 * t35 ; t46 = muDoubleScalarCos ( rtB .
hkbmt1bwgv [ 5 ] * 4.0 ) - 1.0 ; t48 = t12 * t12 * rtP . Ii_33 ; t49 = rtP .
Ii_33 * t21 * t36 * t41 ; t50 = rtP . Ii_22 * t24 * t32 * t36 ; t51 = rtP .
Ii_22 * t21 * t32 * t40 ; t52 = rtP . Ii_33 * t24 * t40 * t41 ; t53 = rtP .
Ii_31 * t11 * t21 * t31 * t32 * t36 * 2.0 ; t54 = rtP . Ii_31 * t11 * t24 *
t31 * t32 * t40 * 2.0 ; t55 = rtP . Ii_31 * t3 * t11 * t30 * t31 * t32 * 2.0
; t56 = rtP . Ii_32 * t2 * t12 * t30 * t31 * 2.0 ; t57 = rtP . Ii_32 * t3 *
t12 * t31 * t37 * 2.0 ; t58 = rtP . Ii_11 * t12 * t21 * t32 * t36 ; t59 = rtP
. Ii_31 * t2 * t11 * t12 * t31 * t37 * 2.0 ; t60 = rtP . Ii_11 * t12 * t24 *
t32 * t40 ; t61 = rtP . Ii_11 * t3 * t12 * t30 * t32 * 2.0 ; t62 = rtP .
Ii_32 * t24 * t30 * t31 * t32 * t37 * 2.0 ; t63 = rtP . Ii_33 * t2 * t12 *
t32 * t37 * 2.0 ; t64 = rtP . Ii_32 * t2 * t3 * t31 * t32 * t40 * 2.0 ; t65 =
rtP . Ii_22 * t2 * t3 * t30 * t32 * t37 * 2.0 ; t66 = rtP . Ii_21 * t11 * t24
* t30 * t32 * t37 * 2.0 ; t67 = rtP . Ii_21 * t2 * t3 * t11 * t32 * t40 * 2.0
; t70 = muDoubleScalarCos ( rtB . hkbmt1bwgv [ 7 ] * 4.0 ) - 1.0 ; t72 = t16
* t16 * rtP . Io_33 ; t73 = rtP . Io_33 * t21 * t38 * t43 ; t74 = rtP . Io_22
* t24 * t35 * t38 ; t75 = rtP . Io_22 * t21 * t35 * t42 ; t76 = rtP . Io_33 *
t24 * t42 * t43 ; t77 = rtP . Io_31 * t15 * t21 * t34 * t35 * t38 * 2.0 ; t78
= rtP . Io_31 * t15 * t24 * t34 * t35 * t42 * 2.0 ; t79 = rtP . Io_31 * t3 *
t15 * t33 * t34 * t35 * 2.0 ; t80 = rtP . Io_32 * t2 * t16 * t33 * t34 * 2.0
; t81 = rtP . Io_32 * t3 * t16 * t34 * t9 * 2.0 ; t82 = rtP . Io_11 * t16 *
t21 * t35 * t38 ; t83 = rtP . Io_31 * t2 * t15 * t16 * t34 * t9 * 2.0 ; t84 =
rtP . Io_11 * t16 * t24 * t35 * t42 ; t85 = rtP . Io_11 * t3 * t16 * t33 *
t35 * 2.0 ; t86 = rtP . Io_32 * t24 * t33 * t34 * t35 * t9 * 2.0 ; t87 = rtP
. Io_33 * t2 * t16 * t35 * t9 * 2.0 ; t88 = rtP . Io_32 * t2 * t3 * t34 * t35
* t42 * 2.0 ; t89 = rtP . Io_22 * t2 * t3 * t33 * t35 * t9 * 2.0 ; t90 = rtP
. Io_21 * t15 * t24 * t33 * t35 * t9 * 2.0 ; t91 = rtP . Io_21 * t2 * t3 *
t15 * t35 * t42 * 2.0 ; t92 = rtB . hkbmt1bwgv [ 3 ] * 2.0 ; t93 = rtB .
hkbmt1bwgv [ 2 ] * 2.0 ; t94 = muDoubleScalarCos ( t92 ) ; t95 =
muDoubleScalarCos ( t93 ) ; t96 = rtB . hkbmt1bwgv [ 5 ] * 2.0 ; t97 =
muDoubleScalarSin ( t93 ) ; t98 = rtB . hkbmt1bwgv [ 5 ] * 3.0 ; t99 =
muDoubleScalarCos ( t98 ) ; t100 = muDoubleScalarSin ( t92 ) ; t101 =
muDoubleScalarSin ( t98 ) ; t102 = muDoubleScalarCos ( t96 ) ; t103 =
muDoubleScalarSin ( t96 ) ; t104 = rtB . hkbmt1bwgv [ 4 ] * 2.0 ; t105 =
muDoubleScalarCos ( t104 ) ; t106 = rtB . hkbmt1bwgv [ 7 ] * 2.0 ; t107 = rtB
. hkbmt1bwgv [ 7 ] * 3.0 ; t108 = muDoubleScalarCos ( t107 ) ; t109 =
muDoubleScalarSin ( t104 ) ; t110 = muDoubleScalarSin ( t107 ) ; t111 =
muDoubleScalarCos ( t106 ) ; t112 = muDoubleScalarSin ( t106 ) ; t113 = ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( t48 + t49 ) + t50
) + t51 ) + t52 ) + t53 ) + t54 ) + t55 ) + t56 ) + t57 ) + t58 ) + t59 ) +
t60 ) + t61 ) + t62 ) + t63 ) + t64 ) + t65 ) + t66 ) + t67 ) - rtP . Ii_11 *
t46 * 0.125 ) - rtP . Ii_31 * t11 * t12 * t31 * 2.0 ) - rtP . Ii_31 * t3 *
t11 * t12 * t30 * t31 * 2.0 ) - rtP . Ii_21 * t2 * t11 * t30 * t32 * 2.0 ) -
rtP . Ii_21 * t3 * t11 * t32 * t37 * 2.0 ) - rtP . Ii_31 * t2 * t11 * t31 *
t32 * t37 * 2.0 ) - rtP . Ii_33 * t3 * t12 * t30 * t32 * 2.0 ) - rtP . Ii_32
* t21 * t30 * t31 * t32 * t37 * 2.0 ) - rtP . Ii_32 * t2 * t3 * t31 * t32 *
t36 * 2.0 ) - rtP . Ii_11 * t2 * t12 * t32 * t37 * 2.0 ) - rtP . Ii_33 * t2 *
t3 * t30 * t37 * t41 * 2.0 ) - rtP . Ii_21 * t11 * t21 * t30 * t32 * t37 *
2.0 ) - rtP . Ii_21 * t2 * t3 * t11 * t32 * t36 * 2.0 ) - rtP . Ii_31 * t2 *
t3 * t11 * t30 * t31 * t32 * t37 * 4.0 ) - rtP . Ii_11 * t2 * t3 * t12 * t30
* t32 * t37 * 2.0 ; t149 = ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( rtP . Ii_32 * t97 * t100 * 0.5 + rtP . Ii_32 * t3 * t30
* 0.5 ) + rtP . Ii_31 * t2 * t11 * t30 * 0.5 ) + rtP . Ii_31 * t3 * t11 * t37
* 0.5 ) + rtP . Ii_32 * t94 * t95 * t102 * 0.5 ) + rtP . Ii_33 * t2 * t30 *
t31 * 0.25 ) + rtP . Ii_33 * t3 * t31 * t37 * 0.25 ) + rtP . Ii_31 * t94 *
t97 * t99 * 0.25 ) + rtP . Ii_31 * t95 * t99 * t100 * 0.25 ) + rtP . Ii_33 *
t94 * t97 * t101 * 0.125 ) + rtP . Ii_33 * t95 * t100 * t101 * 0.125 ) + rtP
. Ii_21 * t97 * t100 * t103 * 0.5 ) + rtP . Ii_32 * t3 * t30 * t102 * 0.5 ) +
rtP . Ii_31 * t2 * t30 * t99 * 0.5 ) + rtP . Ii_31 * t3 * t37 * t99 * 0.5 ) +
rtP . Ii_33 * t2 * t30 * t101 * 0.25 ) + rtP . Ii_33 * t3 * t37 * t101 * 0.25
) + rtP . Ii_21 * t2 * t37 * t103 * 0.5 ) + rtP . Ii_22 * t31 * t94 * t97 *
0.5 ) + rtP . Ii_22 * t31 * t95 * t100 * 0.5 ) - rtP . Ii_32 * t94 * t95 *
0.5 ) - rtP . Ii_32 * t2 * t37 * 0.5 ) - rtP . Ii_11 * t2 * t30 * t31 * 0.25
) - rtP . Ii_11 * t3 * t31 * t37 * 0.25 ) - rtP . Ii_21 * t94 * t95 * t103 *
0.5 ) - rtP . Ii_11 * t94 * t97 * t101 * 0.125 ) - rtP . Ii_11 * t95 * t100 *
t101 * 0.125 ) - rtP . Ii_32 * t97 * t100 * t102 * 0.5 ) - rtP . Ii_21 * t3 *
t30 * t103 * 0.5 ) - rtP . Ii_11 * t2 * t30 * t101 * 0.25 ) - rtP . Ii_11 *
t3 * t37 * t101 * 0.25 ) - rtP . Ii_32 * t2 * t37 * t102 * 0.5 ) - rtP .
Ii_31 * t11 * t94 * t97 * 0.25 ) - rtP . Ii_31 * t11 * t95 * t100 * 0.25 ) -
rtP . Ii_11 * t31 * t94 * t97 * 0.125 ) - rtP . Ii_11 * t31 * t95 * t100 *
0.125 ) - rtP . Ii_33 * t31 * t94 * t97 * 0.375 ) - rtP . Ii_33 * t31 * t95 *
t100 * 0.375 ; t45 = ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( t72 + t73 ) + t74 ) + t75 ) + t76 ) + t77 ) + t78 ) + t79 ) + t80 )
+ t81 ) + t82 ) + t83 ) + t84 ) + t85 ) + t86 ) + t87 ) + t88 ) + t89 ) + t90
) + t91 ) - rtP . Io_11 * t70 * 0.125 ) - rtP . Io_31 * t15 * t16 * t34 * 2.0
) - rtP . Io_31 * t3 * t15 * t16 * t33 * t34 * 2.0 ) - rtP . Io_21 * t2 * t15
* t33 * t35 * 2.0 ) - rtP . Io_21 * t3 * t15 * t35 * t9 * 2.0 ) - rtP . Io_31
* t2 * t15 * t34 * t35 * t9 * 2.0 ) - rtP . Io_33 * t3 * t16 * t33 * t35 *
2.0 ) - rtP . Io_32 * t21 * t33 * t34 * t35 * t9 * 2.0 ) - rtP . Io_32 * t2 *
t3 * t34 * t35 * t38 * 2.0 ) - rtP . Io_11 * t2 * t16 * t35 * t9 * 2.0 ) -
rtP . Io_33 * t2 * t3 * t33 * t9 * t43 * 2.0 ) - rtP . Io_21 * t15 * t21 *
t33 * t35 * t9 * 2.0 ) - rtP . Io_21 * t2 * t3 * t15 * t35 * t38 * 2.0 ) -
rtP . Io_31 * t2 * t3 * t15 * t33 * t34 * t35 * t9 * 4.0 ) - rtP . Io_11 * t2
* t3 * t16 * t33 * t35 * t9 * 2.0 ; t186 = ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( rtP . Io_32 * t97 * t109 * 0.5 + rtP .
Io_32 * t3 * t33 * 0.5 ) + rtP . Io_31 * t2 * t15 * t33 * 0.5 ) + rtP . Io_31
* t3 * t15 * t9 * 0.5 ) + rtP . Io_32 * t95 * t105 * t111 * 0.5 ) + rtP .
Io_33 * t2 * t33 * t34 * 0.25 ) + rtP . Io_33 * t3 * t34 * t9 * 0.25 ) + rtP
. Io_31 * t97 * t105 * t108 * 0.25 ) + rtP . Io_31 * t95 * t108 * t109 * 0.25
) + rtP . Io_33 * t97 * t105 * t110 * 0.125 ) + rtP . Io_33 * t95 * t109 *
t110 * 0.125 ) + rtP . Io_21 * t97 * t109 * t112 * 0.5 ) + rtP . Io_32 * t3 *
t33 * t111 * 0.5 ) + rtP . Io_31 * t2 * t33 * t108 * 0.5 ) + rtP . Io_31 * t3
* t9 * t108 * 0.5 ) + rtP . Io_33 * t2 * t33 * t110 * 0.25 ) + rtP . Io_33 *
t3 * t9 * t110 * 0.25 ) + rtP . Io_21 * t2 * t9 * t112 * 0.5 ) + rtP . Io_22
* t34 * t97 * t105 * 0.5 ) + rtP . Io_22 * t34 * t95 * t109 * 0.5 ) - rtP .
Io_32 * t95 * t105 * 0.5 ) - rtP . Io_32 * t2 * t9 * 0.5 ) - rtP . Io_11 * t2
* t33 * t34 * 0.25 ) - rtP . Io_11 * t3 * t34 * t9 * 0.25 ) - rtP . Io_21 *
t95 * t105 * t112 * 0.5 ) - rtP . Io_11 * t97 * t105 * t110 * 0.125 ) - rtP .
Io_11 * t95 * t109 * t110 * 0.125 ) - rtP . Io_32 * t97 * t109 * t111 * 0.5 )
- rtP . Io_21 * t3 * t33 * t112 * 0.5 ) - rtP . Io_11 * t2 * t33 * t110 *
0.25 ) - rtP . Io_11 * t3 * t9 * t110 * 0.25 ) - rtP . Io_32 * t2 * t9 * t111
* 0.5 ) - rtP . Io_31 * t15 * t97 * t105 * 0.25 ) - rtP . Io_31 * t15 * t95 *
t109 * 0.25 ) - rtP . Io_11 * t34 * t97 * t105 * 0.125 ) - rtP . Io_11 * t34
* t95 * t109 * 0.125 ) - rtP . Io_33 * t34 * t97 * t105 * 0.375 ) - rtP .
Io_33 * t34 * t95 * t109 * 0.375 ; t160 = ( ( ( ( ( ( ( ( ( ( ( ( rtP . Ir_32
* t23 * t24 + rtP . Ir_32 * t3 * t18 ) + rtP . Ir_31 * t2 * t17 * t18 ) + rtP
. Ir_22 * t2 * t3 * t22 ) + rtP . Ir_21 * t17 * t22 * t24 ) + rtP . Ir_33 *
t2 * t18 * t22 ) - rtP . Ir_32 * t21 * t23 ) - rtP . Ir_11 * t2 * t18 * t22 )
- rtP . Ir_21 * t3 * t17 * t22 ) - rtP . Ir_31 * t2 * t17 * t23 ) - rtP .
Ir_21 * t17 * t21 * t22 ) - rtP . Ir_11 * t2 * t3 * t18 * t22 ) - rtP . Ir_31
* t2 * t3 * t17 * t23 * 2.0 ) - rtP . Ir_33 * t2 * t3 * t22 * t23 ; t92 = ( (
( ( ( ( ( ( ( ( ( ( rtP . Il_32 * t20 * t24 + rtP . Il_32 * t3 * t14 ) + rtP
. Il_31 * t2 * t13 * t14 ) + rtP . Il_22 * t2 * t3 * t19 ) + rtP . Il_21 *
t13 * t19 * t24 ) + rtP . Il_33 * t2 * t14 * t19 ) - rtP . Il_32 * t20 * t21
) - rtP . Il_11 * t2 * t14 * t19 ) - rtP . Il_21 * t3 * t13 * t19 ) - rtP .
Il_31 * t2 * t13 * t20 ) - rtP . Il_21 * t13 * t19 * t21 ) - rtP . Il_11 * t2
* t3 * t14 * t19 ) - rtP . Il_31 * t2 * t3 * t13 * t20 * 2.0 ) - rtP . Il_33
* t2 * t3 * t19 * t20 ; oclxa3gpdt [ 0 ] = t4 ; oclxa3gpdt [ 1 ] = 0.0 ;
oclxa3gpdt [ 2 ] = t7 ; oclxa3gpdt [ 3 ] = 0.0 ; oclxa3gpdt [ 4 ] = 0.0 ;
oclxa3gpdt [ 5 ] = 0.0 ; oclxa3gpdt [ 6 ] = 0.0 ; oclxa3gpdt [ 7 ] = 0.0 ;
oclxa3gpdt [ 8 ] = 0.0 ; oclxa3gpdt [ 9 ] = 0.0 ; oclxa3gpdt [ 10 ] = t4 ;
oclxa3gpdt [ 11 ] = t10 ; oclxa3gpdt [ 12 ] = 0.0 ; oclxa3gpdt [ 13 ] = 0.0 ;
oclxa3gpdt [ 14 ] = 0.0 ; oclxa3gpdt [ 15 ] = 0.0 ; oclxa3gpdt [ 16 ] = 0.0 ;
oclxa3gpdt [ 17 ] = 0.0 ; oclxa3gpdt [ 18 ] = t7 ; oclxa3gpdt [ 19 ] = t10 ;
oclxa3gpdt [ 20 ] = ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( ( ( ( ( ( rtP . Ic_33 + t48 ) + t49 ) + t50 ) + t51 ) + t52 ) + t53 ) + t54
) + t55 ) + t56 ) + t57 ) + t58 ) + t59 ) + t60 ) + t61 ) + t62 ) + t63 ) +
t64 ) + t65 ) + t66 ) + t67 ) + t72 ) + t73 ) + t74 ) + t75 ) + t76 ) + t77 )
+ t78 ) + t79 ) + t80 ) + t81 ) + t82 ) + t83 ) + t84 ) + t85 ) + t86 ) + t87
) + t88 ) + t89 ) + t90 ) + t91 ) - rtP . Ii_11 * t46 * 0.125 ) - rtP . Io_11
* t70 * 0.125 ) - ( muDoubleScalarCos ( rtB . hkbmt1bwgv [ 6 ] * 4.0 ) - 1.0
) * rtP . Il_11 * 0.125 ) - ( muDoubleScalarCos ( rtB . hkbmt1bwgv [ 8 ] *
4.0 ) - 1.0 ) * rtP . Ir_11 * 0.125 ) + t14 * t14 * rtP . Il_33 ) + t18 * t18
* rtP . Ir_33 ) + rtP . Il_22 * t20 * t24 ) + rtP . Ir_22 * t23 * t24 ) + rtP
. mc * t21 * t26 ) + rtP . mc * t24 * t26 ) + rtP . mi * t21 * t25 ) + rtP .
mi * t21 * t27 * 0.25 ) + rtP . mi * t24 * t25 ) + rtP . mi * t24 * t27 *
0.25 ) + rtP . ml * t21 * t27 * 0.25 ) + rtP . ml * t24 * t27 * 0.25 ) + rtP
. mo * t21 * t25 ) + rtP . mo * t21 * t27 * 0.25 ) + rtP . mo * t24 * t25 ) +
rtP . mo * t24 * t27 * 0.25 ) + rtP . mr * t21 * t27 * 0.25 ) + rtP . mr *
t24 * t27 * 0.25 ) + t20 * t20 * rtP . Il_33 * t21 ) + rtP . Ir_33 * t21 * (
t23 * t23 ) ) - rtP . Ii_31 * t11 * t12 * t31 * 2.0 ) - rtP . Il_11 * t3 *
t14 * ( t14 - 1.0 ) * 2.0 ) + rtP . Il_21 * t2 * t13 * ( t14 - 1.0 ) * 2.0 )
+ rtP . Il_11 * t14 * t20 * t21 ) - rtP . Il_31 * t13 * t14 * t19 * 2.0 ) +
rtP . Il_33 * t3 * t14 * ( t14 - 1.0 ) * 2.0 ) - rtP . Io_31 * t15 * t16 *
t34 * 2.0 ) - rtP . Ir_11 * t3 * t18 * ( t18 - 1.0 ) * 2.0 ) + rtP . Ir_21 *
t2 * t17 * ( t18 - 1.0 ) * 2.0 ) + rtP . Ir_11 * t18 * t21 * t23 ) + rtP .
Ir_33 * t3 * t18 * ( t18 - 1.0 ) * 2.0 ) - rtP . Ir_31 * t17 * t18 * t22 *
2.0 ) - rtP . Il_32 * t2 * t19 * ( t20 - 1.0 ) * 2.0 ) - rtP . Ir_32 * t2 *
t22 * ( t23 - 1.0 ) * 2.0 ) - rtP . Ii_11 * t2 * t12 * t32 * t37 * 2.0 ) -
rtP . Ii_21 * t2 * t11 * t30 * t32 * 2.0 ) - rtP . Ii_21 * t3 * t11 * t32 *
t37 * 2.0 ) - rtP . Ii_33 * t3 * t12 * t30 * t32 * 2.0 ) - rtP . Il_21 * t2 *
t3 * t13 * t20 * 2.0 ) - rtP . Il_32 * t2 * t3 * t19 * t20 * 2.0 ) - rtP .
Il_31 * t3 * t13 * t14 * t19 * 2.0 ) + rtP . Il_31 * t3 * t13 * t19 * t20 *
2.0 ) + rtP . Il_31 * t13 * t19 * t20 * t21 * 2.0 ) - rtP . Io_11 * t2 * t16
* t35 * t9 * 2.0 ) - rtP . Io_21 * t2 * t15 * t33 * t35 * 2.0 ) - rtP . Io_21
* t3 * t15 * t35 * t9 * 2.0 ) - rtP . Io_33 * t3 * t16 * t33 * t35 * 2.0 ) -
rtP . Ir_21 * t2 * t3 * t17 * t23 * 2.0 ) - rtP . Ir_32 * t2 * t3 * t22 * t23
* 2.0 ) - rtP . Ir_31 * t3 * t17 * t18 * t22 * 2.0 ) + rtP . Ir_31 * t3 * t17
* t22 * t23 * 2.0 ) + rtP . Ir_31 * t17 * t21 * t22 * t23 * 2.0 ) - rtP .
Ii_21 * t2 * t3 * t11 * t32 * t36 * 2.0 ) - rtP . Ii_31 * t3 * t11 * t12 *
t30 * t31 * 2.0 ) - rtP . Ii_32 * t2 * t3 * t31 * t32 * t36 * 2.0 ) - rtP .
Ii_31 * t2 * t11 * t31 * t32 * t37 * 2.0 ) - rtP . Ii_33 * t2 * t3 * t30 *
t37 * t41 * 2.0 ) - rtP . Ii_21 * t11 * t21 * t30 * t32 * t37 * 2.0 ) - rtP .
Ii_32 * t21 * t30 * t31 * t32 * t37 * 2.0 ) - rtP . Io_21 * t2 * t3 * t15 *
t35 * t38 * 2.0 ) - rtP . Io_31 * t3 * t15 * t16 * t33 * t34 * 2.0 ) - rtP .
Io_32 * t2 * t3 * t34 * t35 * t38 * 2.0 ) - rtP . Io_33 * t2 * t3 * t33 * t9
* t43 * 2.0 ) - rtP . Io_31 * t2 * t15 * t34 * t35 * t9 * 2.0 ) - rtP . Io_21
* t15 * t21 * t33 * t35 * t9 * 2.0 ) - rtP . Io_32 * t21 * t33 * t34 * t35 *
t9 * 2.0 ) - rtP . Ii_11 * t2 * t3 * t12 * t30 * t32 * t37 * 2.0 ) - rtP .
Io_11 * t2 * t3 * t16 * t33 * t35 * t9 * 2.0 ) - rtP . Ii_31 * t2 * t3 * t11
* t30 * t31 * t32 * t37 * 4.0 ) - rtP . Io_31 * t2 * t3 * t15 * t33 * t34 *
t35 * t9 * 4.0 ; oclxa3gpdt [ 21 ] = t113 ; oclxa3gpdt [ 22 ] = t45 ;
oclxa3gpdt [ 23 ] = t149 ; oclxa3gpdt [ 24 ] = t186 ; oclxa3gpdt [ 25 ] =
t160 ; oclxa3gpdt [ 26 ] = t92 ; oclxa3gpdt [ 27 ] = 0.0 ; oclxa3gpdt [ 28 ]
= 0.0 ; oclxa3gpdt [ 29 ] = t113 ; oclxa3gpdt [ 30 ] = t113 ; oclxa3gpdt [ 31
] = 0.0 ; oclxa3gpdt [ 32 ] = t149 ; oclxa3gpdt [ 33 ] = 0.0 ; oclxa3gpdt [
34 ] = 0.0 ; oclxa3gpdt [ 35 ] = 0.0 ; oclxa3gpdt [ 36 ] = 0.0 ; oclxa3gpdt [
37 ] = 0.0 ; oclxa3gpdt [ 38 ] = t45 ; oclxa3gpdt [ 39 ] = 0.0 ; oclxa3gpdt [
40 ] = t45 ; oclxa3gpdt [ 41 ] = 0.0 ; oclxa3gpdt [ 42 ] = t186 ; oclxa3gpdt
[ 43 ] = 0.0 ; oclxa3gpdt [ 44 ] = 0.0 ; oclxa3gpdt [ 45 ] = 0.0 ; oclxa3gpdt
[ 46 ] = 0.0 ; oclxa3gpdt [ 47 ] = t149 ; oclxa3gpdt [ 48 ] = t149 ;
oclxa3gpdt [ 49 ] = 0.0 ; oclxa3gpdt [ 50 ] = ( ( ( ( ( ( ( ( ( ( ( ( ( ( ( (
( rtP . Ii_22 * 0.5 + rtP . Ii_33 * 0.5 ) + rtP . Ii_11 * t12 * 0.5 ) - rtP .
Ii_33 * t12 * 0.5 ) + rtP . Ii_31 * t103 * 0.5 ) + rtP . Ii_22 * t94 * t95 *
0.5 ) - rtP . Ii_22 * t97 * t100 * 0.5 ) - rtP . Ii_33 * t94 * t95 * 0.5 ) +
rtP . Ii_33 * t97 * t100 * 0.5 ) - rtP . Ii_11 * t12 * t94 * t95 * 0.5 ) +
rtP . Ii_11 * t12 * t97 * t100 * 0.5 ) + rtP . Ii_21 * t11 * t94 * t97 ) +
rtP . Ii_21 * t11 * t95 * t100 ) + rtP . Ii_33 * t12 * t94 * t95 * 0.5 ) -
rtP . Ii_33 * t12 * t97 * t100 * 0.5 ) + rtP . Ii_32 * t31 * t94 * t97 ) +
rtP . Ii_32 * t31 * t95 * t100 ) - rtP . Ii_31 * t11 * t31 * t94 * t95 ) +
rtP . Ii_31 * t11 * t31 * t97 * t100 ; oclxa3gpdt [ 51 ] = 0.0 ; oclxa3gpdt [
52 ] = 0.0 ; oclxa3gpdt [ 53 ] = 0.0 ; oclxa3gpdt [ 54 ] = 0.0 ; oclxa3gpdt [
55 ] = 0.0 ; oclxa3gpdt [ 56 ] = t186 ; oclxa3gpdt [ 57 ] = 0.0 ; oclxa3gpdt
[ 58 ] = t186 ; oclxa3gpdt [ 59 ] = 0.0 ; oclxa3gpdt [ 60 ] = ( ( ( ( ( ( ( (
( ( ( ( ( ( ( ( ( rtP . Io_22 * 0.5 + rtP . Io_33 * 0.5 ) + rtP . Io_11 * t16
* 0.5 ) - rtP . Io_33 * t16 * 0.5 ) + rtP . Io_31 * t112 * 0.5 ) + rtP .
Io_22 * t95 * t105 * 0.5 ) - rtP . Io_22 * t97 * t109 * 0.5 ) - rtP . Io_33 *
t95 * t105 * 0.5 ) + rtP . Io_33 * t97 * t109 * 0.5 ) - rtP . Io_11 * t16 *
t95 * t105 * 0.5 ) + rtP . Io_11 * t16 * t97 * t109 * 0.5 ) + rtP . Io_21 *
t15 * t97 * t105 ) + rtP . Io_21 * t15 * t95 * t109 ) + rtP . Io_33 * t16 *
t95 * t105 * 0.5 ) - rtP . Io_33 * t16 * t97 * t109 * 0.5 ) + rtP . Io_32 *
t34 * t97 * t105 ) + rtP . Io_32 * t34 * t95 * t109 ) - rtP . Io_31 * t15 *
t34 * t95 * t105 ) + rtP . Io_31 * t15 * t34 * t97 * t109 ; oclxa3gpdt [ 61 ]
= 0.0 ; oclxa3gpdt [ 62 ] = 0.0 ; oclxa3gpdt [ 63 ] = 0.0 ; oclxa3gpdt [ 64 ]
= 0.0 ; oclxa3gpdt [ 65 ] = t160 ; oclxa3gpdt [ 66 ] = 0.0 ; oclxa3gpdt [ 67
] = 0.0 ; oclxa3gpdt [ 68 ] = 0.0 ; oclxa3gpdt [ 69 ] = 0.0 ; oclxa3gpdt [ 70
] = ( ( ( ( rtP . Ir_11 * t18 * t24 + rtP . Ir_22 * t21 ) + rtP . Ir_33 * t23
* t24 ) + rtP . Ir_21 * t2 * t3 * t17 * 2.0 ) + rtP . Ir_32 * t2 * t3 * t22 *
2.0 ) + rtP . Ir_31 * t17 * t22 * t24 * 2.0 ; oclxa3gpdt [ 71 ] = 0.0 ;
oclxa3gpdt [ 72 ] = 0.0 ; oclxa3gpdt [ 73 ] = 0.0 ; oclxa3gpdt [ 74 ] = t92 ;
oclxa3gpdt [ 75 ] = 0.0 ; oclxa3gpdt [ 76 ] = 0.0 ; oclxa3gpdt [ 77 ] = 0.0 ;
oclxa3gpdt [ 78 ] = 0.0 ; oclxa3gpdt [ 79 ] = 0.0 ; oclxa3gpdt [ 80 ] = ( ( (
( rtP . Il_11 * t14 * t24 + rtP . Il_22 * t21 ) + rtP . Il_33 * t20 * t24 ) +
rtP . Il_21 * t2 * t3 * t13 * 2.0 ) + rtP . Il_32 * t2 * t3 * t19 * 2.0 ) +
rtP . Il_31 * t13 * t19 * t24 * 2.0 ; for ( p1 = 0 ; p1 < 3 ; p1 ++ ) { for (
p2 = 0 ; p2 < 9 ; p2 ++ ) { mjespxcs1o [ p1 + 3 * p2 ] = 0.0 ; for ( p3 = 0 ;
p3 < 9 ; p3 ++ ) { mjespxcs1o [ p1 + 3 * p2 ] += nn5hyolh34 [ 9 * p1 + p3 ] *
oclxa3gpdt [ 9 * p2 + p3 ] ; } } for ( p2 = 0 ; p2 < 3 ; p2 ++ ) { ehrq52oenb
[ p1 + 3 * p2 ] = 0.0 ; for ( p3 = 0 ; p3 < 9 ; p3 ++ ) { ehrq52oenb [ p1 + 3
* p2 ] += mjespxcs1o [ 3 * p3 + p1 ] * nn5hyolh34 [ 9 * p2 + p3 ] ; } } }
memcpy ( & x [ 0 ] , & ehrq52oenb [ 0 ] , 9U * sizeof ( real_T ) ) ; p1 = 0 ;
p2 = 3 ; p3 = 6 ; t2 = muDoubleScalarAbs ( ehrq52oenb [ 0 ] ) ; t3 =
muDoubleScalarAbs ( ehrq52oenb [ 1 ] ) ; t10 = muDoubleScalarAbs ( ehrq52oenb
[ 2 ] ) ; if ( ( t3 > t2 ) && ( t3 > t10 ) ) { p1 = 3 ; p2 = 0 ; x [ 0 ] =
ehrq52oenb [ 1 ] ; x [ 1 ] = ehrq52oenb [ 0 ] ; x [ 3 ] = ehrq52oenb [ 4 ] ;
x [ 4 ] = ehrq52oenb [ 3 ] ; x [ 6 ] = ehrq52oenb [ 7 ] ; x [ 7 ] =
ehrq52oenb [ 6 ] ; } else { if ( t10 > t2 ) { p1 = 6 ; p3 = 0 ; x [ 0 ] =
ehrq52oenb [ 2 ] ; x [ 2 ] = ehrq52oenb [ 0 ] ; x [ 3 ] = ehrq52oenb [ 5 ] ;
x [ 5 ] = ehrq52oenb [ 3 ] ; x [ 6 ] = ehrq52oenb [ 8 ] ; x [ 8 ] =
ehrq52oenb [ 6 ] ; } } t10 = x [ 1 ] / x [ 0 ] ; x [ 1 ] /= x [ 0 ] ; t2 = x
[ 2 ] / x [ 0 ] ; x [ 2 ] /= x [ 0 ] ; x [ 4 ] -= t10 * x [ 3 ] ; x [ 5 ] -=
t2 * x [ 3 ] ; x [ 7 ] -= t10 * x [ 6 ] ; x [ 8 ] -= t2 * x [ 6 ] ; if (
muDoubleScalarAbs ( x [ 5 ] ) > muDoubleScalarAbs ( x [ 4 ] ) ) { itmp = p2 ;
p2 = p3 ; p3 = itmp ; x [ 1 ] = t2 ; x [ 2 ] = t10 ; t2 = x [ 4 ] ; x [ 4 ] =
x [ 5 ] ; x [ 5 ] = t2 ; t2 = x [ 7 ] ; x [ 7 ] = x [ 8 ] ; x [ 8 ] = t2 ; }
t2 = x [ 5 ] / x [ 4 ] ; x [ 5 ] /= x [ 4 ] ; x [ 8 ] -= t2 * x [ 7 ] ; t3 =
( x [ 5 ] * x [ 1 ] - x [ 2 ] ) / x [ 8 ] ; t2 = - ( x [ 7 ] * t3 + x [ 1 ] )
/ x [ 4 ] ; ehrq52oenb [ p1 ] = ( ( 1.0 - x [ 3 ] * t2 ) - x [ 6 ] * t3 ) / x
[ 0 ] ; ehrq52oenb [ p1 + 1 ] = t2 ; ehrq52oenb [ p1 + 2 ] = t3 ; t3 = - x [
5 ] / x [ 8 ] ; t2 = ( 1.0 - x [ 7 ] * t3 ) / x [ 4 ] ; ehrq52oenb [ p2 ] = -
( x [ 3 ] * t2 + x [ 6 ] * t3 ) / x [ 0 ] ; ehrq52oenb [ p2 + 1 ] = t2 ;
ehrq52oenb [ p2 + 2 ] = t3 ; t3 = 1.0 / x [ 8 ] ; t2 = - x [ 7 ] * t3 / x [ 4
] ; ehrq52oenb [ p3 ] = - ( x [ 3 ] * t2 + x [ 6 ] * t3 ) / x [ 0 ] ;
ehrq52oenb [ p3 + 1 ] = t2 ; ehrq52oenb [ p3 + 2 ] = t3 ; t2 = rtB .
hkbmt1bwgv [ 2 ] + rtB . hkbmt1bwgv [ 3 ] ; t3 = rtB . hkbmt1bwgv [ 2 ] + rtB
. hkbmt1bwgv [ 4 ] ; memset ( & R6_th_i [ 0 ] , 0 , 81U * sizeof ( real_T ) )
; R6_th_i [ 0 ] = muDoubleScalarCos ( t2 ) ; R6_th_i [ 9 ] = -
muDoubleScalarSin ( t2 ) ; R6_th_i [ 1 ] = muDoubleScalarSin ( t2 ) ; R6_th_i
[ 10 ] = muDoubleScalarCos ( t2 ) ; for ( p1 = 0 ; p1 < 7 ; p1 ++ ) { for (
p2 = 0 ; p2 < 7 ; p2 ++ ) { R6_th_i [ ( p2 + 9 * ( 2 + p1 ) ) + 2 ] =
varargin_2 [ 7 * p1 + p2 ] ; } } memset ( & R6_th_o [ 0 ] , 0 , 81U * sizeof
( real_T ) ) ; R6_th_o [ 0 ] = muDoubleScalarCos ( t3 ) ; R6_th_o [ 9 ] = -
muDoubleScalarSin ( t3 ) ; R6_th_o [ 1 ] = muDoubleScalarSin ( t3 ) ; R6_th_o
[ 10 ] = muDoubleScalarCos ( t3 ) ; for ( p1 = 0 ; p1 < 7 ; p1 ++ ) { for (
p2 = 0 ; p2 < 7 ; p2 ++ ) { R6_th_o [ ( p2 + 9 * ( 2 + p1 ) ) + 2 ] =
varargin_2 [ 7 * p1 + p2 ] ; } } t2 = 0.0 ; t3 = 0.0 ; t10 = 0.0 ; t31 = rtP
. a * rtP . a * rtP . Cp_1 / ( rtP . mu_1 * rtP . Fz_1 ) *
0.66666666666666663 ; t17 = rtP . a * rtP . a * rtP . Cp_2 / ( rtP . mu_2 *
rtP . Fz_2 ) * 0.66666666666666663 ; t24 = 1.0 - t31 * 0.0 ; t15 = 1.0 - t17
* 0.0 ; if ( t31 != 0.0 ) { if ( 0.0 <= 1.0 / t31 ) { t31 = rtP . mu_1 * ( (
rtP . mc / 4.0 + rtP . mi ) * rtP . g ) * ( 1.0 - muDoubleScalarPower ( t24 ,
3.0 ) ) ; } else { t31 = rtP . mu_1 * ( ( rtP . mc / 4.0 + rtP . mi ) * rtP .
g ) ; } t5 = t31 * 0.0 > 0.0 ? ( rtInf ) : t31 * 0.0 < 0.0 ? ( rtMinusInf ) :
( rtNaN ) ; t31 = t31 * 0.0 > 0.0 ? ( rtInf ) : t31 * 0.0 < 0.0 ? (
rtMinusInf ) : ( rtNaN ) ; t2 = - ( muDoubleScalarPower ( t24 , 3.0 ) / ( (
1.0 + t24 ) + t24 * t24 ) * rtP . a ) * t31 ; } else { t5 = 0.0 ; t31 = 0.0 ;
} if ( t17 != 0.0 ) { if ( 0.0 <= 1.0 / t17 ) { t17 = rtP . mu_2 * ( ( rtP .
mc / 4.0 + rtP . mi ) * rtP . g ) * ( 1.0 - muDoubleScalarPower ( t15 , 3.0 )
) ; } else { t17 = rtP . mu_2 * ( ( rtP . mc / 4.0 + rtP . mi ) * rtP . g ) ;
} t24 = t17 * 0.0 > 0.0 ? ( rtInf ) : t17 * 0.0 < 0.0 ? ( rtMinusInf ) : (
rtNaN ) ; t17 = t17 * 0.0 > 0.0 ? ( rtInf ) : t17 * 0.0 < 0.0 ? ( rtMinusInf
) : ( rtNaN ) ; t3 = - ( muDoubleScalarPower ( t15 , 3.0 ) / ( ( 1.0 + t15 )
+ t15 * t15 ) * rtP . a ) * t17 ; } else { t24 = 0.0 ; t17 = 0.0 ; }
idbbxhzzmc ( oclxa3gpdt , Q , X_p ) ; memset ( & R [ 0 ] , 0 , 81U * sizeof (
creal_T ) ) ; if ( jg3q0qpu5h ( X_p ) ) { for ( p1 = 0 ; p1 < 9 ; p1 ++ ) { R
[ p1 + 9 * p1 ] = X_p [ 9 * p1 + p1 ] ; jflkbipdbe ( & R [ p1 + 9 * p1 ] ) ;
} } else { for ( p2 = 0 ; p2 < 9 ; p2 ++ ) { R [ p2 + 9 * p2 ] = X_p [ 9 * p2
+ p2 ] ; jflkbipdbe ( & R [ p2 + 9 * p2 ] ) ; for ( p3 = p2 - 1 ; p3 + 1 > 0
; p3 -- ) { t15 = 0.0 ; t9 = 0.0 ; for ( p1 = p3 + 1 ; p1 + 1 <= p2 ; p1 ++ )
{ t15 += R [ 9 * p1 + p3 ] . re * R [ 9 * p2 + p1 ] . re - R [ 9 * p1 + p3 ]
. im * R [ 9 * p2 + p1 ] . im ; t9 += R [ 9 * p1 + p3 ] . re * R [ 9 * p2 +
p1 ] . im + R [ 9 * p1 + p3 ] . im * R [ 9 * p2 + p1 ] . re ; } t11 = R [ 9 *
p3 + p3 ] . re + R [ 9 * p2 + p2 ] . re ; t8 = R [ 9 * p3 + p3 ] . im + R [ 9
* p2 + p2 ] . im ; t15 = X_p [ 9 * p2 + p3 ] . re - t15 ; t9 = X_p [ 9 * p2 +
p3 ] . im - t9 ; if ( t8 == 0.0 ) { if ( t9 == 0.0 ) { R [ p3 + 9 * p2 ] . re
= t15 / t11 ; R [ p3 + 9 * p2 ] . im = 0.0 ; } else if ( t15 == 0.0 ) { R [
p3 + 9 * p2 ] . re = 0.0 ; R [ p3 + 9 * p2 ] . im = t9 / t11 ; } else { R [
p3 + 9 * p2 ] . re = t15 / t11 ; R [ p3 + 9 * p2 ] . im = t9 / t11 ; } } else
if ( t11 == 0.0 ) { if ( t15 == 0.0 ) { R [ p3 + 9 * p2 ] . re = t9 / t8 ; R
[ p3 + 9 * p2 ] . im = 0.0 ; } else if ( t9 == 0.0 ) { R [ p3 + 9 * p2 ] . re
= 0.0 ; R [ p3 + 9 * p2 ] . im = - ( t15 / t8 ) ; } else { R [ p3 + 9 * p2 ]
. re = t9 / t8 ; R [ p3 + 9 * p2 ] . im = - ( t15 / t8 ) ; } } else { t13 =
muDoubleScalarAbs ( t11 ) ; t14 = muDoubleScalarAbs ( t8 ) ; if ( t13 > t14 )
{ t13 = t8 / t11 ; t8 = t13 * t8 + t11 ; R [ p3 + 9 * p2 ] . re = ( t13 * t9
+ t15 ) / t8 ; R [ p3 + 9 * p2 ] . im = ( t9 - t13 * t15 ) / t8 ; } else if (
t14 == t13 ) { t11 = t11 > 0.0 ? 0.5 : - 0.5 ; t8 = t8 > 0.0 ? 0.5 : - 0.5 ;
R [ p3 + 9 * p2 ] . re = ( t15 * t11 + t9 * t8 ) / t13 ; R [ p3 + 9 * p2 ] .
im = ( t9 * t11 - t15 * t8 ) / t13 ; } else { t13 = t11 / t8 ; t8 += t13 *
t11 ; R [ p3 + 9 * p2 ] . re = ( t13 * t15 + t9 ) / t8 ; R [ p3 + 9 * p2 ] .
im = ( t13 * t9 - t15 ) / t8 ; } } } } } for ( p1 = 0 ; p1 < 9 ; p1 ++ ) {
for ( p2 = 0 ; p2 < 9 ; p2 ++ ) { Q_p [ p1 + 9 * p2 ] . re = 0.0 ; Q_p [ p1 +
9 * p2 ] . im = 0.0 ; for ( p3 = 0 ; p3 < 9 ; p3 ++ ) { Q_p [ p1 + 9 * p2 ] .
re += Q [ 9 * p3 + p1 ] . re * R [ 9 * p2 + p3 ] . re - Q [ 9 * p3 + p1 ] .
im * R [ 9 * p2 + p3 ] . im ; Q_p [ p1 + 9 * p2 ] . im += Q [ 9 * p3 + p1 ] .
re * R [ 9 * p2 + p3 ] . im + Q [ 9 * p3 + p1 ] . im * R [ 9 * p2 + p3 ] . re
; } } for ( p2 = 0 ; p2 < 9 ; p2 ++ ) { X_p [ p1 + 9 * p2 ] . re = 0.0 ; X_p
[ p1 + 9 * p2 ] . im = 0.0 ; for ( p3 = 0 ; p3 < 9 ; p3 ++ ) { t15 = Q [ 9 *
p3 + p2 ] . re ; t8 = - Q [ 9 * p3 + p2 ] . im ; X_p [ p1 + 9 * p2 ] . re +=
Q_p [ 9 * p3 + p1 ] . re * t15 - Q_p [ 9 * p3 + p1 ] . im * t8 ; X_p [ p1 + 9
* p2 ] . im += Q_p [ 9 * p3 + p1 ] . re * t8 + Q_p [ 9 * p3 + p1 ] . im * t15
; } } } p1 = 0 ; exitg1 = false ; while ( ( ! exitg1 ) && ( p1 < 9 ) ) { t15
= 0.0 ; for ( p2 = 0 ; p2 < 9 ; p2 ++ ) { t15 += muDoubleScalarHypot ( X_p [
9 * p1 + p2 ] . re , X_p [ 9 * p1 + p2 ] . im ) ; } if ( muDoubleScalarIsNaN
( t15 ) ) { t10 = ( rtNaN ) ; exitg1 = true ; } else { if ( t15 > t10 ) { t10
= t15 ; } p1 ++ ; } } for ( p1 = 0 ; p1 < 81 ; p1 ++ ) { X_i [ p1 ] = X_p [
p1 ] . im ; } if ( ebbzxa51eo ( X_i ) <= 1.9984014443252818E-14 * t10 ) { for
( p1 = 0 ; p1 < 9 ; p1 ++ ) { for ( p2 = 0 ; p2 < 9 ; p2 ++ ) { X_p [ p2 + 9
* p1 ] . im = 0.0 ; } } } for ( p1 = 0 ; p1 < 81 ; p1 ++ ) { krg2bizi3l [ p1
] = X_p [ p1 ] . re ; } dxh5jlqdfh ( oclxa3gpdt , & rtB . fdaowiniar ) ;
dxh5jlqdfh ( krg2bizi3l , & rtB . lyhikfrpp3 ) ; for ( p1 = 0 ; p1 < 6 ; p1
++ ) { for ( p2 = 0 ; p2 < 9 ; p2 ++ ) { B_1delta [ p1 + 6 * p2 ] = 0.0 ; for
( p3 = 0 ; p3 < 9 ; p3 ++ ) { B_1delta [ p1 + 6 * p2 ] += pypyr02emi [ 6 * p3
+ p1 ] * rtB . lyhikfrpp3 . n01yyskxy4 [ 9 * p2 + p3 ] ; } pB_1delta [ p2 + 9
* p1 ] = B_1delta [ 6 * p2 + p1 ] ; } } b_p = false ; for ( p1 = 0 ; p1 < 54
; p1 ++ ) { X_e [ p1 ] = 0.0 ; if ( b_p || muDoubleScalarIsInf ( pB_1delta [
p1 ] ) || muDoubleScalarIsNaN ( pB_1delta [ p1 ] ) ) { b_p = true ; } } if (
b_p ) { for ( p1 = 0 ; p1 < 54 ; p1 ++ ) { X_e [ p1 ] = ( rtNaN ) ; } } else
{ otuiewre2g ( pB_1delta , U , s , V ) ; t10 = muDoubleScalarAbs ( s [ 0 ] )
; if ( ( ! muDoubleScalarIsInf ( t10 ) ) && ( ! muDoubleScalarIsNaN ( t10 ) )
) { if ( t10 <= 2.2250738585072014E-308 ) { t10 = 4.94065645841247E-324 ; }
else { frexp ( t10 , & r ) ; t10 = ldexp ( 1.0 , r - 53 ) ; } } else { t10 =
( rtNaN ) ; } t10 *= 9.0 ; r = 0 ; p1 = 1 ; while ( ( p1 < 7 ) && ( s [ p1 -
1 ] > t10 ) ) { r ++ ; p1 ++ ; } if ( r > 0 ) { p2 = 0 ; for ( p1 = 1 ; p1 <=
r ; p1 ++ ) { t10 = 1.0 / s [ p1 - 1 ] ; for ( p3 = p2 ; p3 + 1 <= p2 + 6 ;
p3 ++ ) { V [ p3 ] *= t10 ; } p2 += 6 ; } for ( p1 = 0 ; p1 <= 49 ; p1 += 6 )
{ for ( p2 = p1 ; p2 + 1 <= p1 + 6 ; p2 ++ ) { X_e [ p2 ] = 0.0 ; } } p1 = -
1 ; for ( p2 = 0 ; p2 <= 49 ; p2 += 6 ) { p3 = - 1 ; p1 ++ ; itmp = ( ( r - 1
) * 9 + p1 ) + 1 ; for ( ib = p1 ; ib + 1 <= itmp ; ib += 9 ) { if ( U [ ib ]
!= 0.0 ) { ia = p3 ; for ( b_ic = p2 ; b_ic + 1 <= p2 + 6 ; b_ic ++ ) { ia ++
; X_e [ b_ic ] += U [ ib ] * V [ ia ] ; } } p3 += 6 ; } } } } for ( p1 = 0 ;
p1 < 6 ; p1 ++ ) { for ( p2 = 0 ; p2 < 9 ; p2 ++ ) { pB_1delta [ p2 + 9 * p1
] = X_e [ 6 * p2 + p1 ] ; } } memset ( & I [ 0 ] , 0 , 81U * sizeof ( int8_T
) ) ; for ( r = 0 ; r < 9 ; r ++ ) { I [ r + 9 * r ] = 1 ; mjespxcs1o [ 3 * r
] = - nn5hyolh34 [ r ] ; mjespxcs1o [ 1 + 3 * r ] = - nn5hyolh34 [ r + 9 ] ;
mjespxcs1o [ 2 + 3 * r ] = - nn5hyolh34 [ r + 18 ] ; } for ( p1 = 0 ; p1 < 3
; p1 ++ ) { for ( p2 = 0 ; p2 < 9 ; p2 ++ ) { mjespxcs1o_p [ p1 + 3 * p2 ] =
0.0 ; for ( p3 = 0 ; p3 < 9 ; p3 ++ ) { mjespxcs1o_p [ p1 + 3 * p2 ] +=
mjespxcs1o [ 3 * p3 + p1 ] * oclxa3gpdt [ 9 * p2 + p3 ] ; } } for ( p2 = 0 ;
p2 < 3 ; p2 ++ ) { x [ p1 + 3 * p2 ] = 0.0 ; for ( p3 = 0 ; p3 < 9 ; p3 ++ )
{ x [ p1 + 3 * p2 ] += mjespxcs1o_p [ 3 * p3 + p1 ] * mxorse3uag [ 9 * p2 +
p3 ] ; } } } for ( p1 = 0 ; p1 < 9 ; p1 ++ ) { for ( p2 = 0 ; p2 < 6 ; p2 ++
) { X_e [ p2 + 6 * p1 ] = - g4r1yovtie [ 6 * p1 + p2 ] ; } } for ( p1 = 0 ;
p1 < 3 ; p1 ++ ) { for ( p2 = 0 ; p2 < 6 ; p2 ++ ) { ns2qq2s0fy [ p2 + 6 * p1
] = 0.0 ; for ( p3 = 0 ; p3 < 9 ; p3 ++ ) { ns2qq2s0fy [ p2 + 6 * p1 ] += X_e
[ 6 * p3 + p2 ] * nn5hyolh34 [ 9 * p1 + p3 ] ; } } } for ( p1 = 0 ; p1 < 9 ;
p1 ++ ) { R6_th_o_p [ p1 ] = 0.0 ; for ( p2 = 0 ; p2 < 9 ; p2 ++ ) {
R6_th_o_p [ p1 ] += rtB . fdaowiniar . n01yyskxy4 [ 9 * p2 + p1 ] *
owi2j0naiy [ p2 ] ; } } for ( p1 = 0 ; p1 < 6 ; p1 ++ ) { s [ p1 ] = 0.0 ;
for ( p2 = 0 ; p2 < 9 ; p2 ++ ) { g4r1yovtie [ p2 + 9 * p1 ] = 0.0 ; for ( p3
= 0 ; p3 < 9 ; p3 ++ ) { g4r1yovtie [ p2 + 9 * p1 ] += krg2bizi3l [ 9 * p3 +
p2 ] * pB_1delta [ 9 * p1 + p3 ] ; } s [ p1 ] += pypyr02emi [ 6 * p2 + p1 ] *
R6_th_o_p [ p2 ] ; } ns2qq2s0fy_p [ p1 ] = ( ns2qq2s0fy [ p1 + 12 ] * rtB .
hkbmt1bwgv [ 11 ] + ( ns2qq2s0fy [ p1 + 6 ] * rtB . hkbmt1bwgv [ 10 ] +
ns2qq2s0fy [ p1 ] * rtB . hkbmt1bwgv [ 9 ] ) ) - s [ p1 ] ; } for ( p1 = 0 ;
p1 < 9 ; p1 ++ ) { R6_th_o_p [ p1 ] = 0.0 ; for ( p2 = 0 ; p2 < 6 ; p2 ++ ) {
R6_th_o_p [ p1 ] += g4r1yovtie [ 9 * p2 + p1 ] * ns2qq2s0fy_p [ p2 ] ; } }
for ( p1 = 0 ; p1 < 3 ; p1 ++ ) { mjespxcs1o_i [ p1 ] = 0.0 ; for ( p2 = 0 ;
p2 < 9 ; p2 ++ ) { mjespxcs1o_i [ p1 ] += nn5hyolh34 [ 9 * p1 + p2 ] *
R6_th_o_p [ p2 ] ; } mjespxcs1o_e [ p1 ] = x [ p1 + 6 ] * rtB . hkbmt1bwgv [
11 ] + ( x [ p1 + 3 ] * rtB . hkbmt1bwgv [ 10 ] + x [ p1 ] * rtB . hkbmt1bwgv
[ 9 ] ) ; } for ( p1 = 0 ; p1 < 9 ; p1 ++ ) { for ( p2 = 0 ; p2 < 9 ; p2 ++ )
{ t10 = 0.0 ; for ( p3 = 0 ; p3 < 6 ; p3 ++ ) { t10 += pB_1delta [ 9 * p3 +
p1 ] * B_1delta [ 6 * p2 + p3 ] ; } X_i [ p1 + 9 * p2 ] = ( real_T ) I [ 9 *
p2 + p1 ] - t10 ; R6_th_i_p [ p2 + 9 * p1 ] = - R6_th_i [ 9 * p1 + p2 ] ; } }
F1_vec [ 0 ] = t5 ; F1_vec [ 1 ] = t31 ; for ( p1 = 0 ; p1 < 7 ; p1 ++ ) {
F1_vec [ p1 + 2 ] = 0.0 ; } for ( p1 = 0 ; p1 < 9 ; p1 ++ ) { for ( p2 = 0 ;
p2 < 9 ; p2 ++ ) { R6_th_i [ p2 + 9 * p1 ] = - R6_th_o [ 9 * p1 + p2 ] ; } }
F2_vec [ 0 ] = t24 ; F2_vec [ 1 ] = t17 ; for ( p1 = 0 ; p1 < 7 ; p1 ++ ) {
F2_vec [ p1 + 2 ] = 0.0 ; } for ( p1 = 0 ; p1 < 9 ; p1 ++ ) { t10 = 0.0 ; for
( p2 = 0 ; p2 < 9 ; p2 ++ ) { t10 += R6_th_i_p [ 9 * p2 + p1 ] * F1_vec [ p2
] ; } x [ p1 ] = ( real_T ) b_a [ p1 ] * t2 + t10 ; t10 = 0.0 ; for ( p2 = 0
; p2 < 9 ; p2 ++ ) { t10 += R6_th_i [ 9 * p2 + p1 ] * F2_vec [ p2 ] ; }
R6_th_o_p [ p1 ] = ( real_T ) b_a [ p1 ] * t3 + t10 ; } for ( p1 = 0 ; p1 < 3
; p1 ++ ) { for ( p2 = 0 ; p2 < 9 ; p2 ++ ) { mjespxcs1o [ p1 + 3 * p2 ] =
0.0 ; for ( p3 = 0 ; p3 < 9 ; p3 ++ ) { mjespxcs1o [ p1 + 3 * p2 ] +=
nn5hyolh34 [ 9 * p1 + p3 ] * X_i [ 9 * p2 + p3 ] ; } } } for ( p1 = 0 ; p1 <
9 ; p1 ++ ) { F1_vec [ p1 ] = x [ p1 ] + R6_th_o_p [ p1 ] ; } for ( p1 = 0 ;
p1 < 3 ; p1 ++ ) { t10 = 0.0 ; mjespxcs1o_m [ p1 ] = 0.0 ; for ( p2 = 0 ; p2
< 9 ; p2 ++ ) { t10 += nn5hyolh34 [ 9 * p1 + p2 ] * owi2j0naiy [ p2 ] ;
mjespxcs1o_m [ p1 ] += mjespxcs1o [ 3 * p2 + p1 ] * F1_vec [ p2 ] ; } rtB .
mx5qtfxqqb [ p1 ] = ( ( mjespxcs1o_e [ p1 ] + mjespxcs1o_i [ p1 ] ) + t10 ) +
mjespxcs1o_m [ p1 ] ; } for ( p1 = 0 ; p1 < 3 ; p1 ++ ) { rtB . m2wc2u3tke [
9 + p1 ] = 0.0 ; rtB . m2wc2u3tke [ 9 + p1 ] += ehrq52oenb [ p1 ] * rtB .
mx5qtfxqqb [ 0 ] ; rtB . m2wc2u3tke [ 9 + p1 ] += ehrq52oenb [ p1 + 3 ] * rtB
. mx5qtfxqqb [ 1 ] ; rtB . m2wc2u3tke [ 9 + p1 ] += ehrq52oenb [ p1 + 6 ] *
rtB . mx5qtfxqqb [ 2 ] ; } UNUSED_PARAMETER ( tid ) ; } void MdlUpdate (
int_T tid ) { UNUSED_PARAMETER ( tid ) ; } void MdlUpdateTID1 ( int_T tid ) {
UNUSED_PARAMETER ( tid ) ; } void MdlDerivatives ( void ) { XDot * _rtXdot ;
_rtXdot = ( ( XDot * ) ssGetdX ( rtS ) ) ; memcpy ( & _rtXdot -> fy10ebt42l [
0 ] , & rtB . m2wc2u3tke [ 0 ] , 12U * sizeof ( real_T ) ) ; } void
MdlProjection ( void ) { } void MdlTerminate ( void ) { { if (
rt_slioCatalogue ( ) != ( NULL ) ) { void * * slioCatalogueAddr =
rt_slioCatalogueAddr ( ) ; rtwCreateSigstreamSlioClient (
rt_GetOSigstreamManager ( ) , rtwGetPointerFromUniquePtr ( rt_slioCatalogue (
) ) ) ; rtwSaveDatasetsToMatFile ( rtwGetPointerFromUniquePtr (
rt_slioCatalogue ( ) ) , rt_GetMatSigstreamLoggingFileName ( ) ) ;
rtwOSigstreamManagerDestroyInstance ( rt_GetOSigstreamManager ( ) ) ;
rtwTerminateSlioCatalogue ( slioCatalogueAddr ) ; * slioCatalogueAddr = (
NULL ) ; } } } void MdlInitializeSizes ( void ) { ssSetNumContStates ( rtS ,
12 ) ; ssSetNumPeriodicContStates ( rtS , 0 ) ; ssSetNumY ( rtS , 0 ) ;
ssSetNumU ( rtS , 0 ) ; ssSetDirectFeedThrough ( rtS , 0 ) ;
ssSetNumSampleTimes ( rtS , 1 ) ; ssSetNumBlocks ( rtS , 37 ) ;
ssSetNumBlockIO ( rtS , 5 ) ; ssSetNumBlockParams ( rtS , 58 ) ; } void
MdlInitializeSampleTimes ( void ) { ssSetSampleTime ( rtS , 0 , 0.0 ) ;
ssSetOffsetTime ( rtS , 0 , 0.0 ) ; } void raccel_set_checksum ( SimStruct *
rtS ) { ssSetChecksumVal ( rtS , 0 , 4026905566U ) ; ssSetChecksumVal ( rtS ,
1 , 3233966698U ) ; ssSetChecksumVal ( rtS , 2 , 2524878481U ) ;
ssSetChecksumVal ( rtS , 3 , 3566277283U ) ; } SimStruct *
raccel_register_model ( void ) { static struct _ssMdlInfo mdlInfo ; ( void )
memset ( ( char * ) rtS , 0 , sizeof ( SimStruct ) ) ; ( void ) memset ( (
char * ) & mdlInfo , 0 , sizeof ( struct _ssMdlInfo ) ) ; ssSetMdlInfoPtr (
rtS , & mdlInfo ) ; { static time_T mdlPeriod [ NSAMPLE_TIMES ] ; static
time_T mdlOffset [ NSAMPLE_TIMES ] ; static time_T mdlTaskTimes [
NSAMPLE_TIMES ] ; static int_T mdlTsMap [ NSAMPLE_TIMES ] ; static int_T
mdlSampleHits [ NSAMPLE_TIMES ] ; static boolean_T mdlTNextWasAdjustedPtr [
NSAMPLE_TIMES ] ; static int_T mdlPerTaskSampleHits [ NSAMPLE_TIMES *
NSAMPLE_TIMES ] ; static time_T mdlTimeOfNextSampleHit [ NSAMPLE_TIMES ] ; {
int_T i ; for ( i = 0 ; i < NSAMPLE_TIMES ; i ++ ) { mdlPeriod [ i ] = 0.0 ;
mdlOffset [ i ] = 0.0 ; mdlTaskTimes [ i ] = 0.0 ; mdlTsMap [ i ] = i ;
mdlSampleHits [ i ] = 1 ; } } ssSetSampleTimePtr ( rtS , & mdlPeriod [ 0 ] )
; ssSetOffsetTimePtr ( rtS , & mdlOffset [ 0 ] ) ; ssSetSampleTimeTaskIDPtr (
rtS , & mdlTsMap [ 0 ] ) ; ssSetTPtr ( rtS , & mdlTaskTimes [ 0 ] ) ;
ssSetSampleHitPtr ( rtS , & mdlSampleHits [ 0 ] ) ; ssSetTNextWasAdjustedPtr
( rtS , & mdlTNextWasAdjustedPtr [ 0 ] ) ; ssSetPerTaskSampleHitsPtr ( rtS ,
& mdlPerTaskSampleHits [ 0 ] ) ; ssSetTimeOfNextSampleHitPtr ( rtS , &
mdlTimeOfNextSampleHit [ 0 ] ) ; } ssSetSolverMode ( rtS ,
SOLVER_MODE_SINGLETASKING ) ; { ssSetBlockIO ( rtS , ( ( void * ) & rtB ) ) ;
( void ) memset ( ( ( void * ) & rtB ) , 0 , sizeof ( B ) ) ; }
ssSetDefaultParam ( rtS , ( real_T * ) & rtP ) ; { real_T * x = ( real_T * )
& rtX ; ssSetContStates ( rtS , x ) ; ( void ) memset ( ( void * ) x , 0 ,
sizeof ( X ) ) ; } { void * dwork = ( void * ) & rtDW ; ssSetRootDWork ( rtS
, dwork ) ; ( void ) memset ( dwork , 0 , sizeof ( DW ) ) ; } { static
DataTypeTransInfo dtInfo ; ( void ) memset ( ( char_T * ) & dtInfo , 0 ,
sizeof ( dtInfo ) ) ; ssSetModelMappingInfo ( rtS , & dtInfo ) ; dtInfo .
numDataTypes = 14 ; dtInfo . dataTypeSizes = & rtDataTypeSizes [ 0 ] ; dtInfo
. dataTypeNames = & rtDataTypeNames [ 0 ] ; dtInfo . BTransTable = &
rtBTransTable ; dtInfo . PTransTable = & rtPTransTable ; }
sliding_car_InitializeDataMapInfo ( ) ; ssSetIsRapidAcceleratorActive ( rtS ,
true ) ; ssSetRootSS ( rtS , rtS ) ; ssSetVersion ( rtS ,
SIMSTRUCT_VERSION_LEVEL2 ) ; ssSetModelName ( rtS , "sliding_car" ) ;
ssSetPath ( rtS , "sliding_car" ) ; ssSetTStart ( rtS , 0.0 ) ; ssSetTFinal (
rtS , 0.1 ) ; { static RTWLogInfo rt_DataLoggingInfo ; rt_DataLoggingInfo .
loggingInterval = NULL ; ssSetRTWLogInfo ( rtS , & rt_DataLoggingInfo ) ; } {
rtliSetLogXSignalInfo ( ssGetRTWLogInfo ( rtS ) , ( NULL ) ) ;
rtliSetLogXSignalPtrs ( ssGetRTWLogInfo ( rtS ) , ( NULL ) ) ; rtliSetLogT (
ssGetRTWLogInfo ( rtS ) , "tout" ) ; rtliSetLogX ( ssGetRTWLogInfo ( rtS ) ,
"" ) ; rtliSetLogXFinal ( ssGetRTWLogInfo ( rtS ) , "" ) ;
rtliSetLogVarNameModifier ( ssGetRTWLogInfo ( rtS ) , "none" ) ;
rtliSetLogFormat ( ssGetRTWLogInfo ( rtS ) , 4 ) ; rtliSetLogMaxRows (
ssGetRTWLogInfo ( rtS ) , 0 ) ; rtliSetLogDecimation ( ssGetRTWLogInfo ( rtS
) , 1 ) ; rtliSetLogY ( ssGetRTWLogInfo ( rtS ) , "" ) ;
rtliSetLogYSignalInfo ( ssGetRTWLogInfo ( rtS ) , ( NULL ) ) ;
rtliSetLogYSignalPtrs ( ssGetRTWLogInfo ( rtS ) , ( NULL ) ) ; } { static
struct _ssStatesInfo2 statesInfo2 ; ssSetStatesInfo2 ( rtS , & statesInfo2 )
; } { static ssPeriodicStatesInfo periodicStatesInfo ;
ssSetPeriodicStatesInfo ( rtS , & periodicStatesInfo ) ; } { static
ssSolverInfo slvrInfo ; static boolean_T contStatesDisabled [ 12 ] ; static
real_T absTol [ 12 ] = { 1.0E-5 , 1.0E-5 , 1.0E-5 , 1.0E-5 , 1.0E-5 , 1.0E-5
, 1.0E-5 , 1.0E-5 , 1.0E-5 , 1.0E-5 , 1.0E-5 , 1.0E-5 } ; static uint8_T
absTolControl [ 12 ] = { 2U , 2U , 2U , 2U , 2U , 2U , 2U , 2U , 2U , 2U , 2U
, 2U } ; ssSetSolverRelTol ( rtS , 0.001 ) ; ssSetStepSize ( rtS , 0.0 ) ;
ssSetMinStepSize ( rtS , 0.0 ) ; ssSetMaxNumMinSteps ( rtS , - 1 ) ;
ssSetMinStepViolatedError ( rtS , 0 ) ; ssSetMaxStepSize ( rtS , 0.002 ) ;
ssSetSolverMaxOrder ( rtS , 5 ) ; ssSetSolverRefineFactor ( rtS , 1 ) ;
ssSetOutputTimes ( rtS , ( NULL ) ) ; ssSetNumOutputTimes ( rtS , 0 ) ;
ssSetOutputTimesOnly ( rtS , 0 ) ; ssSetOutputTimesIndex ( rtS , 0 ) ;
ssSetZCCacheNeedsReset ( rtS , 0 ) ; ssSetDerivCacheNeedsReset ( rtS , 0 ) ;
ssSetNumNonContDerivSigInfos ( rtS , 0 ) ; ssSetNonContDerivSigInfos ( rtS ,
( NULL ) ) ; ssSetSolverInfo ( rtS , & slvrInfo ) ; ssSetSolverName ( rtS ,
"ode15s" ) ; ssSetVariableStepSolver ( rtS , 1 ) ;
ssSetSolverConsistencyChecking ( rtS , 0 ) ; ssSetSolverAdaptiveZcDetection (
rtS , 0 ) ; ssSetSolverRobustResetMethod ( rtS , 0 ) ; ssSetAbsTolVector (
rtS , absTol ) ; ssSetAbsTolControlVector ( rtS , absTolControl ) ;
ssSetSolverAbsTol_Obsolete ( rtS , absTol ) ;
ssSetSolverAbsTolControl_Obsolete ( rtS , absTolControl ) ;
ssSetSolverStateProjection ( rtS , 0 ) ; ssSetSolverMassMatrixType ( rtS , (
ssMatrixType ) 0 ) ; ssSetSolverMassMatrixNzMax ( rtS , 0 ) ;
ssSetModelOutputs ( rtS , MdlOutputs ) ; ssSetModelLogData ( rtS ,
rt_UpdateTXYLogVars ) ; ssSetModelLogDataIfInInterval ( rtS ,
rt_UpdateTXXFYLogVars ) ; ssSetModelUpdate ( rtS , MdlUpdate ) ;
ssSetModelDerivatives ( rtS , MdlDerivatives ) ;
ssSetSolverMaxConsecutiveMinStep ( rtS , 1 ) ;
ssSetSolverShapePreserveControl ( rtS , 2 ) ; ssSetTNextTid ( rtS , INT_MIN )
; ssSetTNext ( rtS , rtMinusInf ) ; ssSetSolverNeedsReset ( rtS ) ;
ssSetNumNonsampledZCs ( rtS , 0 ) ; ssSetContStateDisabled ( rtS ,
contStatesDisabled ) ; ssSetSolverMaxConsecutiveMinStep ( rtS , 1 ) ; }
ssSetChecksumVal ( rtS , 0 , 4026905566U ) ; ssSetChecksumVal ( rtS , 1 ,
3233966698U ) ; ssSetChecksumVal ( rtS , 2 , 2524878481U ) ; ssSetChecksumVal
( rtS , 3 , 3566277283U ) ; { static const sysRanDType rtAlwaysEnabled =
SUBSYS_RAN_BC_ENABLE ; static RTWExtModeInfo rt_ExtModeInfo ; static const
sysRanDType * systemRan [ 16 ] ; gblRTWExtModeInfo = & rt_ExtModeInfo ;
ssSetRTWExtModeInfo ( rtS , & rt_ExtModeInfo ) ;
rteiSetSubSystemActiveVectorAddresses ( & rt_ExtModeInfo , systemRan ) ;
systemRan [ 0 ] = & rtAlwaysEnabled ; systemRan [ 1 ] = & rtAlwaysEnabled ;
systemRan [ 2 ] = & rtAlwaysEnabled ; systemRan [ 3 ] = & rtAlwaysEnabled ;
systemRan [ 4 ] = & rtAlwaysEnabled ; systemRan [ 5 ] = & rtAlwaysEnabled ;
systemRan [ 6 ] = & rtAlwaysEnabled ; systemRan [ 7 ] = & rtAlwaysEnabled ;
systemRan [ 8 ] = & rtAlwaysEnabled ; systemRan [ 9 ] = & rtAlwaysEnabled ;
systemRan [ 10 ] = & rtAlwaysEnabled ; systemRan [ 11 ] = & rtAlwaysEnabled ;
systemRan [ 12 ] = & rtAlwaysEnabled ; systemRan [ 13 ] = & rtAlwaysEnabled ;
systemRan [ 14 ] = & rtAlwaysEnabled ; systemRan [ 15 ] = & rtAlwaysEnabled ;
rteiSetModelMappingInfoPtr ( ssGetRTWExtModeInfo ( rtS ) , &
ssGetModelMappingInfo ( rtS ) ) ; rteiSetChecksumsPtr ( ssGetRTWExtModeInfo (
rtS ) , ssGetChecksums ( rtS ) ) ; rteiSetTPtr ( ssGetRTWExtModeInfo ( rtS )
, ssGetTPtr ( rtS ) ) ; } return rtS ; } const int_T gblParameterTuningTid =
1 ; void MdlOutputsParameterSampleTime ( int_T tid ) { UNUSED_PARAMETER ( tid
) ; }
