#include "__cf_sliding_car.h"
#ifndef RTW_HEADER_sliding_car_cap_host_h_
#define RTW_HEADER_sliding_car_cap_host_h_
#ifdef HOST_CAPI_BUILD
#include "rtw_capi.h"
#include "rtw_modelmap.h"
typedef struct { rtwCAPI_ModelMappingInfo mmi ; }
sliding_car_host_DataMapInfo_T ;
#ifdef __cplusplus
extern "C" {
#endif
void sliding_car_host_InitializeDataMapInfo ( sliding_car_host_DataMapInfo_T
* dataMap , const char * path ) ;
#ifdef __cplusplus
}
#endif
#endif
#endif
