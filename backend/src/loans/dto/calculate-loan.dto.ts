import { IsEnum, IsNotEmpty, IsNumber, IsOptional, Min } from 'class-validator';
import { LoanType } from '../schemas/loan.schema';

export class CalculateLoanDto {
  @IsEnum(LoanType)
  @IsNotEmpty()
  loanType: LoanType;

  @IsNumber()
  @Min(0)
  @IsNotEmpty()
  principalAmount: number;

  @IsNumber()
  @Min(0)
  @IsNotEmpty()
  annualInterestRate: number;

  @IsNumber()
  @Min(1)
  @IsNotEmpty()
  termInMonths: number;

  @IsNumber()
  @Min(0)
  @IsOptional()
  downPayment?: number;
}
