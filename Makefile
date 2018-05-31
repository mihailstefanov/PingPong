TARGET = program


######################################
# building variables
######################################
# debug build?
DEBUG = 1
# optimization
OPT = -Og


#######################################
# paths
#######################################
# source path
SOURCES_DIR =  \
Drivers \
Drivers/CMSIS \
Drivers/STM32L0xx_HAL_Driver \
Drivers/BSP/B-L072Z-LRWAN1 \
Drivers/BSP/Components/sx1276 \
Drivers/BSP/MLM32L07X01 \
Middlewares/Third_Party/Lora/Utilities \
Application/MAKEFILE \
Application \
Application/User

# firmware library path
PERIFLIB_PATH =

# Build path
BUILD_DIR = build

######################################
# source
######################################
# C sources
C_SOURCES =  \
Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal.c \
Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_adc.c \
Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_adc_ex.c \
Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_cortex.c \
Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_dma.c \
Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_gpio.c \
Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_i2c.c \
Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_pwr.c \
Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_pwr_ex.c \
Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_rcc.c \
Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_rcc_ex.c \
Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_rtc.c \
Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_rtc_ex.c \
Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_spi.c \
Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_tim.c \
Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_tim_ex.c \
Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_uart.c \
Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_uart_ex.c \
Drivers/CMSIS/Device/ST/STM32L0xx/Source/Templates/system_stm32l0xx.c \
Middlewares/Third_Party/Lora/Utilities/delay.c \
Middlewares/Third_Party/Lora/Utilities/low_power_manager.c \
Middlewares/Third_Party/Lora/Utilities/timeServer.c \
Middlewares/Third_Party/Lora/Utilities/utilities.c \
Drivers/BSP/B-L072Z-LRWAN1/b-l072z-lrwan1.c \
Drivers/BSP/Components/sx1276/sx1276.c \
Drivers/BSP/MLM32L07X01/mlm32l07x01.c \
Src/debug.c \
Src/hw_gpio.c \
Src/hw_rtc.c \
Src/hw_spi.c \
Src/main.c \
Src/mlm32l0xx_hal_msp.c \
Src/mlm32l0xx_hw.c \
Src/mlm32l0xx_it.c \
Src/vcom.c 

# ASM sources
ASM_SOURCES =  \
startup_stm32l072xx.s


######################################
# firmware library
######################################
PERIFLIB_SOURCES =


#######################################
# binaries
#######################################
BINPATH = /opt/gcc-arm-none-eabi-7-2017-q4-major/bin
PREFIX = arm-none-eabi-
CC = $(BINPATH)/$(PREFIX)gcc
AS = $(BINPATH)/$(PREFIX)gcc -x assembler-with-cpp
CP = $(BINPATH)/$(PREFIX)objcopy
AR = $(BINPATH)/$(PREFIX)ar
SZ = $(BINPATH)/$(PREFIX)size
HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S

#######################################
# CFLAGS
#######################################
# cpu
CPU = -mcpu=cortex-m0plus

# fpu
#FPU = -mfpu=fpv4-sp-d16

# float-abi
FLOAT-ABI = -mfloat-abi=soft

# mcu
MCU = $(CPU) -mthumb $(FPU) $(FLOAT-ABI)

# macros for gcc
# AS defines
AS_DEFS =

# C defines
C_DEFS =  \
-DSTM32L072xx \
-DUSE_B_L072Z_LRWAN1 \
-DUSE_HAL_DRIVER \
-DUSE_BAND_868 \
-DUSE_MODEM_LORA


# AS includes
AS_INCLUDES =

# C includes
C_INCLUDES =  \
-IInc \
-IDrivers/CMSIS/Include \
-IDrivers/STM32L0xx_HAL_Driver/Inc \
-IDrivers/BSP/B-L072Z-LRWAN1 \
-IDrivers/BSP/Components/sx1276 \
-IDrivers/CMSIS/Device/ST/STM32L0xx/Include \
-IMiddlewares/Third_Party/Lora/Phy \
-IMiddlewares/Third_Party/Lora/Utilities


# compile gcc flags
ASFLAGS = $(MCU) $(AS_DEFS) $(AS_INCLUDES) $(OPT) -Wall  -ffunction-sections

CFLAGS = $(MCU) $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall -ffunction-sections

ifeq ($(DEBUG), 1)
CFLAGS += -g -gdwarf-2
endif


# Generate dependency information
CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)"


#######################################
# LDFLAGS
#######################################
# link script
LDSCRIPT = STM32L072CZYx_FLASH.ld

# libraries
LIBS = -lc -lm -lnosys
LIBDIR =
LDFLAGS = $(MCU) -specs=nano.specs -T$(LDSCRIPT) $(LIBDIR) $(LIBS) -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref -Wl,--gc-sections

# default action: build all
all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin


#######################################
# build the application
#######################################
# list of objects
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))
# list of ASM program objects
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SOURCES)))

$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR)
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

$(BUILD_DIR)/%.o: %.s Makefile | $(BUILD_DIR)
	$(AS) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) Makefile
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	$(SZ) $@

$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(HEX) $< $@

$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(BIN) $< $@

$(BUILD_DIR):
	mkdir $@

#######################################
# clean up
#######################################
clean:
	-rm -fR .dep $(BUILD_DIR)

#######################################
# dependencies
#######################################
-include $(shell mkdir .dep 2>/dev/null) $(wildcard .dep/*)

# *** EOF ***
