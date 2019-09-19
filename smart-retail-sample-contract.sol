pragma solidity ^0.4.25;

contract SmartRetailSampleContract
{

    //Set of States
    //製造, 配送中, 受取
    enum StateType { InProduction, InTransit, Completed }

    //List of properties
    StateType public  State;
    address public  InitiatingCounterparty;
    address public  Counterparty;
    address public  PreviousCounterparty;
    address public  SupplyChainOwner; //My Address
	int public ContractReference;

    //List of events
	event TransferResp(address who);
	event ContractComplete(int reference);

    //初期化
    constructor (address supplyChainOwner, int contractNumber) public
    {
        InitiatingCounterparty = msg.sender;
        Counterparty = InitiatingCounterparty;
        SupplyChainOwner = supplyChainOwner;
        State = StateType.InProduction;
		ContractReference = contractNumber;
    }

    function TransferResponsibility(address newCounterparty) public
    {
        if (Counterparty != msg.sender || State == StateType.Completed)
        {
            revert(); //コントラクトの実行停止
        }

        if (State == StateType.InProduction)
        {
            State = StateType.InTransit;
        }

        PreviousCounterparty = Counterparty;
        Counterparty = newCounterparty;

		emit TransferResp(msg.sender); //トランザクションへのログ出力
    }

    function Complete() public
    {
        if (SupplyChainOwner != msg.sender || State == StateType.Completed)
        {
            revert();
        }

        State = StateType.Completed;
        PreviousCounterparty = Counterparty;
        Counterparty = 0x0;

		emit ContractComplete(ContractReference);
    }
}