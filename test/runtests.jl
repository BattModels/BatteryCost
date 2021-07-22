using BatteryCost
using Test
cell1 = cell()
cost1 = BatteryCost.cost_default()
cell3,cost3 = BatteryCost.convert_all(cell1,cost1,mult)
@test cost_calc(cell3,cost3)==(209.68524992517177, 1708.1761931921092)
