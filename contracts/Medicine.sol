pragma solidity >=0.4.25 <0.6.0;

/********************************************** Medicine ******************************************/
/// @title Medicine
/// @notice
/// @dev something
contract Medicine {

    /// @notice
    address Owner;

    enum MedicineStatus {
        atcreator,
        picked4W,
        picked4D,
        deliveredatW,
        deliveredatD,
        picked4P,
        deliveredatP
    }

    // address batchid;
    bytes32 description;
    /// @notice
    bytes32 rawmaterials;
    /// @notice
    uint quantity;
    /// @notice
    address shipper;
    /// @notice
    address manufacturer;
    /// @notice
    address wholesaler;
    /// @notice
    address distributor;
    /// @notice
    address pharma;
    /// @notice
    MedicineStatus status;

    event ShipmentUpdate(
        address indexed BatchID,
        address indexed Shipper,
        address indexed Receiver,
        uint TransporterType,
        uint Status
    );

    /// @notice
    /// @dev Create new Medicine Batch by Manufacturer
    /// @param Manu Manufacturer Ethereum Network Address
    /// @param Des Description of Medicine Batch
    /// @param RM RawMaterials for Medicine
    /// @param Quant Number of units
    /// @param Shpr Transporter Ethereum Network Address
    /// @param Rcvr Receiver Ethereum Network Address
    /// @param RcvrType Receiver Type either Wholesaler(1) or distributor(2)
    constructor(
        address Manu,
        bytes32 Des,
        bytes32 RM,
        uint Quant,
        address Shpr,
        address Rcvr,
        uint RcvrType
    ) public {
        Owner = Manu;
        manufacturer = Manu;
        description = Des;
        rawmaterials = RM;
        quantity = Quant;
        shipper = Shpr;
        if(RcvrType == 1) {
            wholesaler = Rcvr;
        } else if( RcvrType == 2){
            distributor = Rcvr;
        }
    }

    /// @notice
    /// @dev Get Medicine Batch basic Details
    /// @return Medicine Batch Details
    function getMedicineInfo () public view returns(
        address Manu,
        bytes32 Des,
        bytes32 RM,
        uint Quant,
        address Shpr
    ) {
        return(
            manufacturer,
            description,
            rawmaterials,
            quantity,
            shipper
        );
    }

    /// @notice
    /// @dev Get address Wholesaler, distributor and Pharma
    /// @return Address Array
    function getWDP() public view returns(
        address[3] memory WDP
    ) {
        return (
            [wholesaler,distributor,pharma]
        );
    }

    /// @notice
    /// @dev Get Medicine Batch Transaction Status
    /// @return Medicine Transaction Status
    function getBatchIDStatus() public view returns(
        uint
    ) {
        return uint(status);
    }

    /// @notice
    /// @dev Pick Medicine Batch by Associate Transporter
    /// @param shpr Transporter Ethereum Network Address
    function pickPackage(
        address shpr
    ) public {
        require(
            shpr == shipper,
            "Only Associate Shipper can call this function"
        );
        require(
            status == MedicineStatus(0),
            "Package must be at Supplier."
        );

        if(wholesaler!=address(0x0)){
            status = MedicineStatus(1);
            emit ShipmentUpdate(address(this),shipper,wholesaler,1,1);
        }else{
            status = MedicineStatus(2);
            emit ShipmentUpdate(address(this),shipper,distributor,1,1);
        }
    }

    /// @notice
    /// @dev Received Medicine Batch by Associated Wholesaler or distributor
    /// @param Rcvr Wholesaler or distributor
    function receivedPackage(
        address Rcvr
    ) public
    returns(uint rcvtype)
    {

        require(
            Rcvr == wholesaler || Rcvr == distributor,
            "Only Associate Wholesaler or Distributor can call this function"
        );

        require(
            uint(status) >= 1,
            "Product not picked up yet"
        );

        if(Rcvr == wholesaler && status == MedicineStatus(1)){
            status = MedicineStatus(3);
            emit ShipmentUpdate(address(this),shipper,wholesaler,2,3);
            return 1;
        } else if(Rcvr == distributor && status == MedicineStatus(2)){
            status = MedicineStatus(4);
            emit ShipmentUpdate(address(this),shipper,distributor,3,4);
            return 2;
        }
    }

    /// @notice
    /// @dev Update Medicine Batch transaction Status(Pick) in between Wholesaler and distributor
    /// @param receiver distributor Ethereum Network Address
    /// @param sender Wholesaler Ethereum Network Address
    function sendWD(
        address receiver,
        address sender
    ) public {
        require(
            wholesaler == sender,
            "this Wholesaler is not Associated."
        );
        distributor = receiver;
        status = MedicineStatus(2);
    }

    /// @notice
    /// @dev Update Medicine Batch transaction Status(Received) in between Wholesaler and distributor
    /// @param receiver distributor
    function recievedWD(
        address receiver
    ) public {
        require(
            distributor == receiver,
            "This distributor is not Associated."
        );
        status = MedicineStatus(4);
    }

    /// @notice
    /// @dev Update Medicine Batch transaction Status(Pick) in between distributor and Pharma
    /// @param receiver Pharma Ethereum Network Address
    /// @param sender distributor Ethereum Network Address
    function sendDP(
        address receiver,
        address sender
    ) public {
        require(
            distributor == sender,
            "this distributor is not Associated."
        );
        pharma = receiver;
        status = MedicineStatus(5);
    }

    /// @notice
    /// @dev Update Medicine Batch transaction Status(Recieved) in between distributor and Pharma
    /// @param receiver Pharma Ethereum Network Address
    function recievedDP(
        address receiver
    ) public {
        require(
            pharma == receiver,
            "This Pharma is not Associated."
        );
        status = MedicineStatus(6);
    }
}
