
############
# commands #
############
SHELL = bash
FC = mpif90
CC = mpicc
CXX = g++
LD = mpif90
CPP = cpp


NETCDF_DIR = /usr

#########
# flags #
#########
# default is 64-bit OpenMP non-hydrostatic build
DEBUG = 
REPRO = Y
VERBOSE =
OPENMP = Y
AVX2 = N
HYDRO = N
32BIT = N

NEMSIOINC = -I$(NEMSIO_INC)

NCEPLIBS_DIR ?= /opt/NCEPlibs/lib
NCEPLIBS = -L$(NCEPLIBS_DIR) -lnemsio_d -lbacio_4 -lsp_v2.0.2_d -lw3emc_d -lw3nco_d

##############################################
# Need to use at least GNU Make version 3.81 #
##############################################
need := 3.81
ok := $(filter $(need),$(firstword $(sort $(MAKE_VERSION) $(need))))
ifneq ($(need),$(ok))
$(error Need at least make version $(need).  Load module gmake/3.81)
endif

NETCDF_ROOT = $(NETCDF_DIR)
INCLUDE ?= -I$(NETCDF_ROOT)/include

FPPFLAGS := -cpp -Wp,-w $(INCLUDE) -fPIC
CFLAGS := $(INCLUDE) -fPIC

FFLAGS := $(INCLUDE) -fcray-pointer -ffree-line-length-none -fno-range-check -fPIC
 
CPPDEFS += -Duse_libMPI -Duse_netCDF -DSPMD -DUSE_LOG_DIAG_FIELD_INFO -Duse_LARGEFILE -DUSE_GFSL63 -DGFS_PHYS -DNO_INLINE_POST
CPPDEFS += -DNEW_TAUCTMAX -DINTERNAL_FILE_NML

ifeq ($(HYDRO),Y)
CPPDEFS += 
else
CPPDEFS += -DMOIST_CAPPA -DUSE_COND
endif

ifeq ($(32BIT),Y)
CPPDEFS += -DOVERLOAD_R4 -DOVERLOAD_R8
else
FFLAGS += -fdefault-double-8 -fdefault-real-8
endif

ifeq ($(AVX2),Y)
FFLAGS += -xCORE-AVX2 -qno-opt-dynamic-align
CFLAGS += -xCORE-AVX2 -qno-opt-dynamic-align
endif

FFLAGS_OPT = -O2 
FFLAGS_REPRO = -O2 -g -fbacktrace
FFLAGS_DEBUG = -O0 -g -fbacktrace -fno-fast-math -ffree-line-length-none -fno-backslash -pedantic -Waliasing -Wampersand -Wline-truncation -Wsurprising -Wtabs -Wunderflow -fdump-core -ffpe-trap=invalid,zero,overflow -fbounds-check -finit-real=nan -finit-integer=9999999 -finit-logical=true -finit-character=35

TRANSCENDENTALS := -fast-transcendentals
FFLAGS_OPENMP = -fopenmp
FFLAGS_VERBOSE = -v -V -what

CFLAGS += -D__IFC 

CFLAGS_OPT = -O2 
CFLAGS_REPRO = -O2 
CFLAGS_OPENMP = -fopenmp
CFLAGS_DEBUG = -O0 -g 

# Optional Testing compile flags.  Mutually exclusive from DEBUG, REPRO, and OPT
# *_TEST will match the production if no new option(s) is(are) to be tested.
FFLAGS_TEST = -O3 -debug minimal -fp-model source -qoverride-limits
CFLAGS_TEST = -O2

#LDFLAGS := -L${ESMF_DIR}/lib/libO3/Darwin.gfortran.64.mpiuni.default/ -L${FMS_DIR}/libFMS/.libs/
LDFLAGS_OPENMP := -fopenmp
LDFLAGS_VERBOSE := -Wl,-V,--verbose,-cref,-M

# start with blank LIBS
LIBS :=

LIBS += -lgfortran

ifneq ($(REPRO),)
CFLAGS += $(CFLAGS_REPRO)
FFLAGS += $(FFLAGS_REPRO)
FAST :=
else ifneq ($(DEBUG),)
CFLAGS += $(CFLAGS_DEBUG)
FFLAGS += $(FFLAGS_DEBUG)
FAST :=
else ifneq ($(TEST),)
CFLAGS += $(CFLAGS_TEST)
FFLAGS += $(FFLAGS_TEST)
FAST :=
else
CFLAGS += $(CFLAGS_OPT)
FFLAGS += $(FFLAGS_OPT)
FAST := $(TRANSCENDENTALS)
endif

ifneq ($(OPENMP),)
CFLAGS += $(CFLAGS_OPENMP)
FFLAGS += $(FFLAGS_OPENMP)
LDFLAGS += $(LDFLAGS_OPENMP)
# to correct a loader bug on gaea: envars below set by module load intel
#LIBS += -L$(INTEL_PATH)/$(INTEL_MAJOR_VERSION)/$(INTEL_MINOR_VERSION)/lib/intel64 -lifcoremt
#LIBS += -lifcoremt
endif

ifneq ($(VERBOSE),)
CFLAGS += $(CFLAGS_VERBOSE)
FFLAGS += $(FFLAGS_VERBOSE)
LDFLAGS += $(LDFLAGS_VERBOSE)
endif

ifneq ($(CALLPYFORT),)
FFLAGS += -I$(CALLPYFORT)/include -DENABLE_CALLPYFORT
LDFLAGS += -L$(CALLPYFORT)/lib -lcallpy 
endif

ifneq ($(GCOV),)
CFLAGS += --coverage
FFLAGS += --coverage
LDFLAGS += --coverage
endif

# static linking of esmf works on darwin
#LIBS += -lFMS -lnetcdff -lnetcdf -llapack -lblas ${ESMF_DIR}/lib/libesmf.a -lstdc++ #-lc -lrt
LIBS += -lFMS -lnetcdff -lnetcdf -llapack -lblas -lesmf #-lc -lrt

LDFLAGS += $(LIBS)
