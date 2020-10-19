# Copyright 1994-2016 The MathWorks, Inc.
#
# File    : raccel_unix.tmf   
#
# Abstract:
#	Template makefile for building a UNIX-based "rapid acceleration"
#       executable from the generated C code.
#
# 	This makefile attempts to conform to the guidelines specified in the
# 	IEEE Std 1003.2-1992 (POSIX) standard. It is designed to be used
#       with GNU Make which is located in matlabroot/rtw/bin.
#
# 	Note that this template is automatically customized by the build
#       procedure to create "<model>.mk"
#
#       The following defines can be used to modify the behavior of the
#	build:
#	  OPT_OPTS       - Optimization options. Default is -O.
#	  CPP_OPTS       - C++ compiler options.
#	  OPTS           - User specific compile options.
#	  USER_SRCS      - Additional user sources, such as files needed by
#			   S-functions.
#	  USER_INCLUDES  - Additional include paths
#			   (i.e. USER_INCLUDES="-Iwhere-ever -Iwhere-ever2")
#
#       To enable debugging:
#         set DEBUG_BUILD = 1 below, which will trigger OPTS=-g and
#          LDFLAGS += -g (may vary with compiler version, see compiler doc)
#
#       This template makefile is designed to be used with a system target
#       file that contains 'rtwgensettings.BuildDirSuffix' see raccel.tlc

#------------------------ Macros read by make_rtw ------------------------------
#
# The following macros are read by the build procedure:
#
#  MAKECMD         - This is the command used to invoke the make utility
#  HOST            - What platform this template makefile is targeted for
#                    (i.e. PC or UNIX)
#  BUILD           - Invoke make from the build procedure (yes/no)?
#  SYS_TARGET_FILE - Name of system target file.

MAKECMD         = /home/brunolnetto/MATLAB/bin/glnxa64/gmake
HOST            = UNIX
BUILD           = yes
SYS_TARGET_FILE = raccel.tlc
BUILD_SUCCESS	= *** Created
COMPILER_TOOL_CHAIN = unix

#---------------------- Tokens expanded by make_rtw ----------------------------
#
# The following tokens, when wrapped with "|>" and "<|" are expanded by the
# build procedure.
#
#  MODEL_NAME          - Name of the Simulink block diagram
#  MODEL_MODULES       - Any additional generated source modules
#  MAKEFILE_NAME       - Name of makefile created from template makefile <model>.mk
#  MATLAB_ROOT         - Path to where MATLAB is installed.
#  S_FUNCTIONS         - List of S-functions.
#  S_FUNCTIONS_LIB     - List of S-functions libraries to link.
#  COMPUTER            - Computer type. See the MATLAB computer command.
#  BUILDARGS           - Options passed in at the command line.
#  EXT_MODE            - yes (1) or no (0): Build for external mode
#  TMW_EXTMODE_TESTING - yes (1) or no (0): Build ext_test.c for external mode
#                        testing.
#  EXTMODE_TRANSPORT   - Name of transport mechanism (e.g. tcpip, serial) for extmode
#  EXTMODE_STATIC      - yes (1) or no (0): Use static instead of dynamic mem alloc.
#  EXTMODE_STATIC_SIZE - Size of static memory allocation buffer.
#  TGT_FCN_LIB         - Target Funtion library to use


MODEL                  = sliding_car
MODULES                = rtGetInf.c rtGetNaN.c rt_nonfinite.c sliding_car_capi.c sliding_car_data.c sliding_car_tgtconn.c rt_logging_mmi.c rtw_modelmap_utils.c rt_logging.c
MAKEFILE               = sliding_car.mk
MATLAB_ROOT            = /home/brunolnetto/MATLAB
ALT_MATLAB_ROOT        = /home/brunolnetto/MATLAB
MATLAB_ROOTQ           = \"/home/brunolnetto/MATLAB\"
MASTER_ANCHOR_DIR      = 
START_DIR              = /home/brunolnetto/github/Robotics4fun/examples/2D-car-like-ackermann/code/car_sliding/code/simulink
S_FUNCTIONS            = rtiostream_utils.c
S_FUNCTIONS_LIB        = $(MATLAB_ROOT)/bin/glnxa64/libmwcoder_target_services.so $(MATLAB_ROOT)/bin/glnxa64/libmwcoder_ParamTuningTgtAppSvc.so
COMPUTER               = GLNXA64
BUILDARGS              =  ISPROTECTINGMODEL=NOTPROTECTING RSIM_SOLVER_SELECTION=2 PCMATLABROOT="/home/brunolnetto/MATLAB" EXT_MODE=1 OPTS="-DSLMSG_ALLOW_SYSTEM_ALLOC -DTGTCONN -DON_TARGET_WAIT_FOR_START=0"
RSIM_PARAMETER_LOADING = 1
ENABLE_SLEXEC_SSBRIDGE = 0

EXT_MODE            = 1
TMW_EXTMODE_TESTING = 0
EXTMODE_TRANSPORT   = 0
EXTMODE_STATIC      = 0
EXTMODE_STATIC_SIZE = 1000000

SOLVER              = 
SOLVER_TYPE         = VariableStep
NUMST               = 1
TID01EQ             = 0
NCSTATES            = 12
MULTITASKING        = 0
TGT_FCN_LIB         = None

MODELREFS           = 
SHARED_SRC          = 
SHARED_SRC_DIR      = 
SHARED_BIN_DIR      = 
SHARED_LIB          = 
OPTIMIZATION_FLAGS  = -O0 -fPIC -DNDEBUG
ADDITIONAL_LDFLAGS  = 
DEFINES_CUSTOM      = 

RACCEL_PARALLEL_EXECUTION = 0
RACCEL_PARALLEL_EXECUTION_NUM_THREADS = 4
RACCEL_NUM_PARALLEL_NODES = 0
RACCEL_PARALLEL_SIMULATOR_TYPE = 0

MODEL_HAS_DYNAMICALLY_LOADED_SFCNS = 0

# To enable debugging:
# set DEBUG_BUILD = 1
DEBUG_BUILD             = 0


#--------------------------- Model and reference models -----------------------
MODELLIB                  = sliding_carlib.a
MODELREF_LINK_LIBS        = 
MODELREF_INC_PATH         = 
RELATIVE_PATH_TO_ANCHOR   = ../../..
# NONE: standalone, SIM: modelref sim, RTW: modelref coder target
MODELREF_TARGET_TYPE       = NONE

GLOBAL_TIMING_ENGINE       = 0

#-- In the case when directory name contains space ---
ifneq ($(MATLAB_ROOT),$(ALT_MATLAB_ROOT))
MATLAB_ROOT := $(ALT_MATLAB_ROOT)
endif

#--------------------------- Solver ---------------------------------------------
RSIM_WITH_SL_SOLVER = 1

#--------------------------- Tool Specifications -------------------------------

include $(MATLAB_ROOT)/rtw/c/tools/unixtools.mk

#----------------------------- External mode -----------------------------------
# Uncomment -DVERBOSE to have information printed to stdout
# To add a new transport layer, see the comments in
#   <matlabroot>/toolbox/simulink/simulink/extmode_transports.m
EXT_CC_OPTS = -DEXT_MODE -D$(COMPUTER) #-DVERBOSE
EXT_LIB     =
EXT_SRC     =
ifeq ($(EXTMODE_TRANSPORT),0) #tcpip
  EXT_SRC = ext_svr.c updown.c ext_work.c rtiostream_interface.c rtiostream_tcpip.c
endif
ifeq ($(EXTMODE_TRANSPORT),1) #serial_win32
  err:
	@echo
	@echo "### ERROR: External mode serial transport only available on win32"
	@echo
endif
ifeq ($(TMW_EXTMODE_TESTING),1)
  EXT_SRC     += ext_test.c
  EXT_CC_OPTS += -DTMW_EXTMODE_TESTING
endif
ifeq ($(EXTMODE_STATIC),1)
  EXT_SRC     += mem_mgr.c
  EXT_CC_OPTS += -DEXTMODE_STATIC -DEXTMODE_STATIC_SIZE=$(EXTMODE_STATIC_SIZE)
endif

#------------------------------Parameter Tuning---------------------------------
PARAM_CC_OPTS = -DRSIM_PARAMETER_LOADING

#------------------------------ Include Path -----------------------------------

MATLAB_INCLUDES = \
	-I$(MATLAB_ROOT)/simulink/include \
	-I$(MATLAB_ROOT)/extern/include \
	-I$(MATLAB_ROOT)/rtw/c/src \
	-I$(MATLAB_ROOT)/rtw/c/src/rapid \
	-I$(MATLAB_ROOT)/rtw/c/raccel \
	-I$(MATLAB_ROOT)/rtw/c/src/ext_mode/common

# Additional includes

ADD_INCLUDES = \
	-I$(START_DIR) \
	-I$(MATLAB_ROOT)/simulink/include/sf_runtime \
	-I$(START_DIR)/slprj/raccel/sliding_car \
	-I$(MATLAB_ROOT)/toolbox/coder/rtiostream/src/utils \



SHARED_INCLUDES =
ifneq ($(SHARED_SRC_DIR),)
SHARED_INCLUDES = -I$(SHARED_SRC_DIR)
endif

INCLUDES = -I. -I$(RELATIVE_PATH_TO_ANCHOR)  $(MATLAB_INCLUDES) $(ADD_INCLUDES) $(USER_INCLUDES) \
	$(INSTRUMENT_INCLUDES) 	$(MODELREF_INC_PATH) $(SHARED_INCLUDES)

#-------------------------------- C Flags --------------------------------------

# Optimization Options
ifndef OPT_OPTS
OPT_OPTS = $(DEFAULT_OPT_OPTS)
endif

# General User Options
ifeq ($(DEBUG_BUILD),0)
DBG_FLAG =
else
#   Set OPTS=-g and any additional flags for debugging
DBG_FLAG = -g
LDFLAGS += -g
endif

# Compiler options, etc:
ifneq ($(OPTIMIZATION_FLAGS),)
CC_OPTS = $(OPTS) $(EXT_CC_OPTS) $(PARAM_CC_OPTS) $(OPTIMIZATION_FLAGS)
else
CC_OPTS = $(OPT_OPTS) $(OPTS) $(EXT_CC_OPTS) $(PARAM_CC_OPTS)
endif

CPP_REQ_DEFINES = -DMODEL=$(MODEL) -DHAVESTDIO -DUNIX

CPP_REQ_DEFINES += -DNRT \
                   -DRSIM_WITH_SL_SOLVER

ifneq ($(ENABLE_SLEXEC_SSBRIDGE), 0)
   CPP_REQ_DEFINES += -DENABLE_SLEXEC_SSBRIDGE=$(ENABLE_SLEXEC_SSBRIDGE)
endif

CPP_REQ_DEFINES += -DMODEL_HAS_DYNAMICALLY_LOADED_SFCNS=$(MODEL_HAS_DYNAMICALLY_LOADED_SFCNS)

ifeq ($(RACCEL_PARALLEL_EXECUTION), 1)
   CPP_REQ_DEFINES += -DRACCEL_ENABLE_PARALLEL_EXECUTION \
		      -DRACCEL_PARALLEL_EXECUTION_NUM_THREADS=$(RACCEL_PARALLEL_EXECUTION_NUM_THREADS) \
		      -DRACCEL_NUM_PARALLEL_NODES=$(RACCEL_NUM_PARALLEL_NODES) \
		      -DRACCEL_PARALLEL_SIMULATOR_TYPE=$(RACCEL_PARALLEL_SIMULATOR_TYPE)
endif

ifeq ($(MULTITASKING),1)
    CPP_REQ_DEFINES += -DRSIM_WITH_SOLVER_MULTITASKING \
                       -DTID01EQ=$(TID01EQ) \
	               -DNUMST=$(NUMST)
endif

CFLAGS = $(ANSI_OPTS) $(DBG_FLAG) $(CC_OPTS) $(DEFINES_CUSTOM) $(CPP_REQ_DEFINES) $(INCLUDES)
CPPFLAGS = $(CPP_ANSI_OPTS) $(DBG_FLAG) $(CPP_OPTS) $(CC_OPTS) $(DEFINES_CUSTOM) $(CPP_REQ_DEFINES) $(INCLUDES)

#----------------------------- Source Files ------------------------------------
USER_SRCS =
SRC_DEP =
ifeq ($(MODELREF_TARGET_TYPE), NONE)
    PRODUCT            = $(MODEL)
    BIN_SETTING        = $(LD) $(LDFLAGS) -o $(PRODUCT)
    BUILD_PRODUCT_TYPE = "executable"
    REQ_SRCS = $(MODEL).c $(MODULES) $(EXT_SRC) \
       raccel_sup.c raccel_mat.c simulink_solver_api.c common_utils.c raccel_utils.c 
    ifneq ($(ENABLE_SLEXEC_SSBRIDGE), 0)
        REQ_SRCS += raccel_main_new.c
    else
        REQ_SRCS += raccel_main.c
    endif

    ifeq ($(MODEL_HAS_DYNAMICALLY_LOADED_SFCNS), 1)
	REQ_SRCS += raccel_sfcn_utils.c
    endif

else
   # Model reference coder target
   PRODUCT            = $(MODELLIB)
   BUILD_PRODUCT_TYPE = "library"
   REQ_SRCS = $(MODULES)
endif

USER_OBJS       = $(addsuffix .o, $(basename $(USER_SRCS)))
LOCAL_USER_OBJS = $(notdir $(USER_OBJS))

SRCS = $(REQ_SRCS) $(S_FUNCTIONS)

OBJS      = $(addsuffix .o, $(basename $(SRCS))) $(USER_OBJS)
LINK_OBJS = $(addsuffix .o, $(basename $(SRCS))) $(LOCAL_USER_OBJS)

SHARED_SRC := $(wildcard $(SHARED_SRC))
SHARED_OBJS = $(addsuffix .o, $(basename $(SHARED_SRC)))

#--------------------------- Link flags & libraries ----------------------------

SYSLIBS = $(EXT_LIB) -lm -ldl

LIBS =
 
LIBS += $(S_FUNCTIONS_LIB) $(INSTRUMENT_LIBS)

BINDIR = $(MATLAB_ROOT)/bin/$(ARCH)
MATLIBS=

ifneq (,$(findstring GLNX,$(COMPUTER)))
  MATLIBS = -Wl,-rpath,$(BINDIR),-L$(BINDIR)
  ifneq ($(ENABLE_SLEXEC_SSBRIDGE), 0)
    MATLIBS += -Wl,-lmwslexec_simbridge
  else
    MATLIBS += -Wl,-lmwsl_solver_rtw
  endif
  ifeq ($(RACCEL_PARALLEL_EXECUTION), 1)
    MATLIBS += -Wl,-lmwslexec_parallel
  endif

  MATLIBS += -Wl,-lmwsl_fileio
  MATLIBS += -Wl,-lmwsl_services
  MATLIBS += -Wl,-lmwsigstream,-lmwslio_core,-lmwslio_clients
  MATLIBS += -Wl,-lmat,-lmx,-lmex,-lut,-lmwmathutil
  MATLIBS += -L$(MATLAB_ROOT)/bin/$(ARCH) -lmwipp -lpthread
endif

ifneq (,$(findstring MAC,$(COMPUTER)))
 LD = $(CPP)
 LDFLAGS += $(ADDITIONAL_LDFLAGS)
 MATLIBS = -Wl,-rpath,$(BINDIR) -Wl,-rpath,@executable_path -Wl,-rpath,@executable_path/$(RELATIVE_PATH_TO_ANCHOR) -L$(BINDIR) -L$(MATLAB_ROOT)/sys/os/$(ARCH)
  ifneq ($(ENABLE_SLEXEC_SSBRIDGE), 0)
    MATLIBS += -lmwslexec_simbridge
  else 
  MATLIBS += -lmwsl_solver_rtw 
  endif
  ifeq ($(RACCEL_PARALLEL_EXECUTION), 1)
    MATLIBS += -lmwslexec_parallel
  endif
  MATLIBS += -lmwsl_fileio
  MATLIBS += -lmwsl_services
  MATLIBS += -lmwsigstream -lmwslio_core -lmwslio_clients
  MATLIBS += -lmat -lmx -lmex -lut -lmwmathutil
  MATLIBS += -L$(MATLAB_ROOT)/bin/$(ARCH) -lmwipp -lpthread
endif

ifeq ($(MATLIBS),)
   err:
	@echo
	@echo "### ERROR: Platform $(COMPUTER) is not supported"
	@echo
endif

# Put this after the above error check so that this only appears in the Makefile
# once so TMF expansion works correctly.  If this were above the error check,
# the error check would be meaningless.
MATLIBS += -lmwsl_log_load_blocks
MATLIBS += -lfixedpoint
MATLIBS += -lmwsl_AsyncioQueue
MATLIBS += -lmwsl_iofile
MATLIBS += -lmwsl_simtarget_instrumentation


#--------------------------------- Rules ---------------------------------------

ifeq ($(MODELREF_TARGET_TYPE),NONE)
$(PRODUCT) : $(OBJS)  $(SHARED_LIB) $(LIBS)  $(MODELREF_LINK_LIBS)
	$(BIN_SETTING) $(LINK_OBJS) $(MODELREF_LINK_LIBS) $(SHARED_LIB) \
		$(LIBS) $(MATLIBS) $(ADDITIONAL_LDFLAGS) $(SYSLIBS)
else
$(PRODUCT) : $(OBJS) $(SHARED_LIB)
	@rm -f $@
	$(AR) ruvs $@ $(LINK_OBJS)
endif
	@echo "$(BUILD_SUCCESS) $(BUILD_PRODUCT_TYPE): $@"

#-------------------------- Standard rules for building modules --------------

ifneq ($(SHARED_SRC_DIR),)
$(SHARED_BIN_DIR)/%.o : $(SHARED_SRC_DIR)/%.c
	cd $(SHARED_BIN_DIR); $(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) $(notdir $?)

$(SHARED_BIN_DIR)/%.o : $(SHARED_SRC_DIR)/%.cpp
	cd $(SHARED_BIN_DIR); $(CPP) -c $(CPPFLAGS) $(GCC_WALL_FLAG_MAX) $(notdir $?)
endif

%.o : %.c
	$(CC) -c -o $(@F) $(CFLAGS) $(GCC_WALL_FLAG) "$<"

%.o : %.cpp
	$(CPP) -c $(CPPFLAGS)$(GCC_WALL_FLAG)  "$<"

%.o : $(RELATIVE_PATH_TO_ANCHOR)/%.c
	$(CC) -c -o $(@F) $(CFLAGS) $(GCC_WALL_FLAG) "$<"

%.o : $(RELATIVE_PATH_TO_ANCHOR)/%.cpp
	$(CPP) -c $(CPPFLAGS) $(GCC_WALL_FLAG) "$<"

%.o : $(MATLAB_ROOT)/rtw/c/raccel/%.c
	$(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) "$<"

%.o : $(MATLAB_ROOT)/rtw/c/src/%.c
	$(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) "$<"

%.o : $(MATLAB_ROOT)/rtw/c/src/rapid/%.c
	$(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) "$<"

%.o : $(MATLAB_ROOT)/rtw/c/src/ext_mode/common/%.c
	$(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) "$<"

%.o : $(MATLAB_ROOT)/rtw/c/src/rtiostream/rtiostreamtcpip/%.c
	$(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) "$<"

%.o : $(MATLAB_ROOT)/rtw/c/src/ext_mode/custom/%.c
	$(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) "$<"

simulink_solver_api.o : $(MATLAB_ROOT)/simulink/include/simulink_solver_api.c
	$(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) "$<"

%.o : $(MATLAB_ROOT)/rtw/c/src/%.c
	$(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) "$<"

%.o : $(MATLAB_ROOT)/simulink/src/%.c
	$(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) "$<"

%.o : $(MATLAB_ROOT)/rtw/c/src/ext_mode/common/%.c
	$(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) "$<"

%.o : $(MATLAB_ROOT)/toolbox/coder/rtiostream/src/utils/%.c
	$(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) "$<"




%.o : $(MATLAB_ROOT)/rtw/c/src/%.cpp
	$(CPP) -c $(CPPFLAGS) "$<"
%.o : $(MATLAB_ROOT)/simulink/src/%.cpp
	$(CPP) -c $(CPPFLAGS) "$<"
%.o : $(MATLAB_ROOT)/rtw/c/src/ext_mode/common/%.cpp
	$(CPP) -c $(CPPFLAGS) "$<"
%.o : $(MATLAB_ROOT)/toolbox/coder/rtiostream/src/utils/%.cpp
	$(CPP) -c $(CPPFLAGS) "$<"


%.o : $(MATLAB_ROOT)/simulink/src/%.c
	$(CC) -c $(CFLAGS) $(GCC_WALL_FLAG_MAX) "$<"

%.o : $(MATLAB_ROOT)/simulink/src/%.cpp
	@$(GCC_TEST_CMD) "$<" $(GCC_TEST_OUT)
	$(CPP) -c $(CPPFLAGS) "$<"

# Libraries:





#----------------------------- Dependencies ------------------------------------

$(OBJS) : $(MAKEFILE) rtw_proj.tmw


$(SHARED_LIB) : $(SHARED_OBJS)
	$(AR) ruvs $@ $(SHARED_OBJS)

#--------- Miscellaneous rules to purge and clean ------------------------------

purge : clean
	\rm -f $(MODEL).c $(MODEL).h $(MODEL)_types.h $(MODEL)_data.c \
		 $(MODEL)_private.h $(MODEL).rtw $(MODULES) rtw_proj.tmw $(MAKEFILE)

clean :
	\rm -f $(LINK_OBJS) $(PROGRAM)

# EOF: raccel_unix.tmf
