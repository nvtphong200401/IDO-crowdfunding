contract Project {
    // Project state
    enum State {
        Fundraising,
        Expired,
        Successful
    },


    // Structs

    struct WithdrawRequest{
        string description;
        uint256 amount;
        uint256 noOfVotes;
        mapping(address => bool) voters;
        bool isCompleted;
        address payable reciptent;
    }

    // Variables
    address payable public creator;
    uint256 public minimumContribution;
    uint256 public deadline;
    uint256 public targetContribution; // required to reach at least this much amount
    uint public completeAt;
    uint256 public raisedAmount; // Total raised amount till now
    uint256 public noOfContributers;
    string public projectTitle;
    string public projectDes;
    State public state = State.Fundraising; 

    mapping (address => uint) public contributiors;
    mapping (uint256 => WithdrawRequest) public withdrawRequests;

    uint256 public numOfWithdrawRequests = 0;

    // Modifiers
    modifier isCreator(){
        require(msg.sender == creator,'You dont have access to perform this operation !');
        _;
    }

    modifier validateExpiry(State _state){
        require(state == _state,'Invalid state');
        require(block.timestamp < deadline,'Deadline has passed !');
        _;
    }


        // Events

    // Event that will be emitted whenever funding will be received
    event FundingReceived(address contributor, uint amount, uint currentTotal);
    // Event that will be emitted whenever withdraw request created
    event WithdrawRequestCreated(
        uint256 requestId,
        string description,
        uint256 amount,
        uint256 noOfVotes,
        bool isCompleted,
        address reciptent
    );
    // Event that will be emitted whenever contributor vote for withdraw request
    event WithdrawVote(address voter, uint totalVote);
    // Event that will be emitted whenever contributor vote for withdraw request
    event AmountWithdrawSuccessful(
        uint256 requestId,
        string description,
        uint256 amount,
        uint256 noOfVotes,
        bool isCompleted,
        address reciptent
    );

    // @dev Create project
    // @return null

   constructor(
       address _creator,
       uint256 _minimumContribution,
       uint256 _deadline,
       uint256 _targetContribution,
       string memory _projectTitle,
       string memory _projectDes
   ) {
       creator = payable(_creator);
       minimumContribution = _minimumContribution;
       deadline = _deadline;
       targetContribution = _targetContribution;
       projectTitle = _projectTitle;
       projectDes = _projectDes;
       raisedAmount = 0;
   }

    function contribute(address _contributor) public validateExpiry(State.Fundraising) payable {
        require(msg.value >= minimumContribution,'Contribution amount is too low !');
        if(contributiors[_contributor] == 0){
            noOfContributers++;
        }
        contributiors[_contributor] += msg.value;
        raisedAmount += msg.value;
        emit FundingReceived(_contributor,msg.value,raisedAmount);
        checkFundingCompleteOrExpire();
    }
}
