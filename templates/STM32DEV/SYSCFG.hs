module {{ modns }}
  ( module {{ modns }}.Peripheral
  , module {{ modns }}.Regs
  , syscfg
  ) where

import Ivory.Language
import Ivory.HW

import {{ modns }}.Peripheral
import {{ modns }}.Regs
import Ivory.BSP.STM32{{ dev }}.RCC
import Ivory.BSP.STM32{{ dev }}.MemoryMap (syscfg_periph_base)

{{#instances}}
{{ name }} :: SYSCFG
{{ name }} = mkSYSCFG {{ name }}_periph_base rccenable rccdisable
  where
  rccenable  = modifyReg rcc_reg_{{ rccEnableReg }} $ setBit   rcc_{{ rccEnableReg }}_{{ rccEnableBit }}
  rccdisable = modifyReg rcc_reg_{{ rccEnableReg }} $ clearBit rcc_{{ rccEnableReg }}_{{ rccEnableBit }}

{{/instances}}
