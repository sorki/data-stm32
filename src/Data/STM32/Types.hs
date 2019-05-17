module Data.STM32.Types where

-- should be kept in sync with templates/STM32/{Core,Family}.hs
-- which is suboptimal!
data Core = CortexM0 | CortexM0Plus | CortexM3 | CortexM4F | CortexM7F
  deriving (Eq, Show)

data Family =
    F0
  | F1
  | F2
  | F3
  | F4
  | F7
  | H7
  | L0
  | L1
  | L4
  | L4Plus -- L4S L4R
  | L5     -- no svd nor cmx data
  -- these are part of mcu/families.nix
  -- but (we) dont have svd files
  | G0
  | G4
  | WB
  | TS
  | MP1
  deriving (Eq, Ord, Show, Read)

supportedFamilies =
  [ F0
  , F1
  , F3
  , F4
  , F7
  , L4 ]

nameToFamily :: String -> Family
nameToFamily = read . fix . drop 5
  where
    fix "L4+" = "L4Plus"
    fix x     = x

-- families from cubemx that we have no svd files for
noSVDs = [
    G0
  , G4
  , WB
  , TS
  , MP1
  ]

core :: Family -> Core
core F0     = CortexM0
core F1     = CortexM3
core F2     = CortexM3
core F3     = CortexM4F
core F4     = CortexM4F
core F7     = CortexM7F
core H7     = CortexM7F
core L0     = CortexM0Plus
core L1     = CortexM3
core L4     = CortexM4F
core L4Plus = CortexM4F
core L5     = CortexM4F
core WB     = CortexM3
core TS     = CortexM3
core _      = CortexM3

fpu :: Core -> String
fpu CortexM0     = "soft"
fpu CortexM0Plus = "soft"
fpu CortexM3     = "soft"
fpu CortexM4F    = "fpv4-sp-d16"
fpu CortexM7F    = "fpv5-sp-d16"

eabi :: Core -> Maybe String
eabi CortexM4F = Just "hard"
eabi CortexM7F = Just "hard"
eabi _         = Nothing

data Periph =
    ADC
  | AFIO -- F1 alternate function controls / remapping, proly good idea to turn it on
  | ATIM
  | GTIM
  | CAN
  | CEC
  | CRC
  | CRYP
  | DAC
  | DBG
  | DCMI
  | DMA
  | DMA2D
  | Ethernet
  | EXTI
  | FLASH
  | FPU
  | FSMC
  | GPIO
  | HASH
  | I2C
  | IWDG
  | LPTIM
  | IRTIM
  -- LTDC
  | MPU -- memory protection unit
  | NVIC
  -- PF
  | PWR
  | QUADSPI
  | RCC
  | RNG
  | RTC
  -- SAI -- serial audio interface
  -- SCB
  -- SDMMC
  -- SPDIF_RX
  | SPI
  -- STK
  | SYSCFG
  | TSC -- touchsensing controller
  | UART
  | USART
  | USB_OTG_FS
  | USB_OTG_HS
  | WWDG
  deriving (Show, Eq, Ord)

supportedPeriphs =
 [ CAN
 , UART
 , GPIO ]

genOneFamilies = [ F1, F2, F4, L1 ]

isGenOne fam = fam `elem` genOneFamilies
isGenTwo = not . isGenOne

driverVersion UART fam | isGenTwo fam           = 3 -- over8, split RDR/TDR registers
driverVersion UART fam | fam `elem` [ F2, F4 ]  = 2 -- over8 featured
driverVersion UART _                            = 1 -- F1

driverVersion GPIO F1 = 1
driverVersion GPIO _  = 2

driverVersion I2C fam | isGenTwo fam = 2
driverVersion I2C fam | isGenOne fam = 1

driverVersion SPI fam | isGenTwo fam = 2
driverVersion SPI fam | isGenOne fam = 1