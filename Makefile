# If SPINN_DIRS is not defined, this is an error!
ifndef SPINN_DIRS
    $(error SPINN_DIRS is not set. Please define SPINN_DIRS (possibly by running "source setup" in the spinnaker tools folder))
endif

SPINN_MPI_BUILD = build
include $(SPINN_DIRS)/make/Makefile.common

#SPINN_COMMON_DEBUG := PRODUCTION_CODE

# Include our own include directory
CFLAGS += -I include $(OTIME) # -D$(SPINN_COMMON_DEBUG)

# Objects
OBJS = mpi.o mpi_allgather_mc.o mpi_bcast_mc.o mpi_core.o mpi_gather.o mpi_recv.o mpi_scatter.o mpi_sdp.o mpi_send.o
BUILD_OBJS = $(OBJS:%.o=$(SPINN_MPI_BUILD)/%.o)

# Headers
HEADERS = mpi.h
INSTALL_HEADERS = $(HEADERS:%.h=$(SPINN_INC_DIR)/%.h)

# Build rules (default)
$(SPINN_MPI_BUILD)/libspinn_mpi.a: $(BUILD_OBJS) 
	$(RM) $@
	$(AR) $@ $(BUILD_OBJS)

$(SPINN_MPI_BUILD)/%.o: src/%.c $(SPINN_MPI_BUILD)
	$(CC) $(CFLAGS) -o $@ $<

$(SPINN_MPI_BUILD):
	$(MKDIR) $@

# Installing rules
install: $(SPINN_LIB_DIR)/libspinn_mpi.a $(INSTALL_HEADERS)

$(SPINN_LIB_DIR)/libspinn_mpi.a: $(SPINN_MPI_BUILD)/libspinn_mpi.a
	$(CP) $< $@

$(SPINN_INC_DIR)/%.h: include/%.h
	$(CP) $< $@

clean:
	$(RM) $(SPINN_MPI_BUILD)/libspinn_mpi.a $(BUILD_OBJS)
