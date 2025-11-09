import { LoanType } from '../schemas/loan.schema';

export class LoanResponseDto {
  id: string;
  userId: string;
  loanType: LoanType;
  principalAmount: number;
  annualInterestRate: number;
  termInMonths: number;
  downPayment?: number;
  monthlyPayment: number;
  totalPayment: number;
  totalInterest: number;
  loanAmount: number;
  title?: string;
  notes?: string;
  createdAt: Date;
  updatedAt: Date;

  constructor(partial: Partial<LoanResponseDto>) {
    Object.assign(this, partial);
  }
}
