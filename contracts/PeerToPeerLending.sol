// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract PeerToPeerLending {
    struct Loan {
        address borrower;
        uint256 amount;
        uint256 interestRate; 
        uint256 duration; 
        uint256 collateral;
        bool isActive;
    }

    mapping(uint256 => Loan) public loans;
    uint256 public loanCount;

    event LoanCreated(uint256 loanId, address borrower, uint256 amount, uint256 interestRate, uint256 duration, uint256 collateral);
    event LoanRepaid(uint256 loanId);
    event LoanDefaulted(uint256 loanId);

    function createLoan(uint256 _amount, uint256 _interestRate, uint256 _duration, uint256 _collateral) external {
        require(_amount > 0, "Amount must be greater than 0");
        require(_collateral >= _amount, "Collateral must be at least equal to the loan amount");

        loanCount++;
        loans[loanCount] = Loan(msg.sender, _amount, _interestRate, _duration, _collateral, true);

        emit LoanCreated(loanCount, msg.sender, _amount, _interestRate, _duration, _collateral);
    }

    function repayLoan(uint256 _loanId) external payable {
        Loan storage loan = loans[_loanId];
        require(loan.isActive, "Loan is not active");
        require(msg.sender == loan.borrower, "Only the borrower can repay the loan");
        require(msg.value == loan.amount + (loan.amount * loan.interestRate / 10000), "Incorrect repayment amount");

        loan.isActive = false;
        emit LoanRepaid(_loanId);
    }

    function checkDefault(uint256 _loanId) external {
        Loan storage loan = loans[_loanId];
        require(loan.isActive, "Loan is not active");
        require(block.timestamp > loan.duration, "Loan duration has not expired");

        loan.isActive = false;
        emit LoanDefaulted(_loanId);
    }
}

