import { IsEnum, IsOptional, IsString } from 'class-validator';
import { LoanType } from '../schemas/loan.schema';

export class UpdateLoanDto {
  @IsString()
  @IsOptional()
  title?: string;

  @IsString()
  @IsOptional()
  notes?: string;
}
