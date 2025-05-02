Owner registers users (SupplyChain.sol).
Supplier creates raw material package (SupplyChain.sol, RawMaterials.sol).
Transporter delivers raw materials to manufacturer (RawMaterials.sol, SupplyChain.sol).
Manufacturer creates medicine batch (SupplyChain.sol, Medicine.sol).
Transporter delivers batch to wholesaler or distributor (Medicine.sol, SupplyChain.sol).
Wholesaler (if involved) transfers to distributor (SupplyChain.sol, MedicineW_D.sol, Medicine.sol).
Distributor transfers to pharmacy (SupplyChain.sol, MedicineD_P.sol, Medicine.sol).
Pharmacy updates sale status (SupplyChain.sol).