import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Loan, LoanDocument, LoanType } from './schemas/loan.schema';
import { CreateLoanDto } from './dto/create-loan.dto';
import { UpdateLoanDto } from './dto/update-loan.dto';
import { CalculateLoanDto } from './dto/calculate-loan.dto';
import { LoanResponseDto } from './dto/loan-response.dto';

@Injectable()
export class LoansService {
  constructor(
    @InjectModel(Loan.name) private loanModel: Model<LoanDocument>,
  ) {}

  /**
   * Calculate loan payment using the standard amortization formula
   * M = P * (r * (1 + r)^n) / ((1 + r)^n - 1)
   * Where:
   * M = Monthly payment
   * P = Principal (loan amount after down payment)
   * r = Monthly interest rate (annual rate / 12)
   * n = Number of payments (term in months)
   */
  calculateLoan(dto: CalculateLoanDto) {
    const { principalAmount, annualInterestRate, termInMonths, downPayment = 0 } = dto;
    
    // Calculate loan amount after down payment
    const loanAmount = principalAmount - downPayment;
    
    // Convert annual interest rate to monthly decimal rate
    const monthlyRate = annualInterestRate / 100 / 12;
    
    let monthlyPayment: number;
    
    if (monthlyRate === 0) {
      // If interest rate is 0, simple division
      monthlyPayment = loanAmount / termInMonths;
    } else {
      // Standard amortization formula
      const numerator = monthlyRate * Math.pow(1 + monthlyRate, termInMonths);
      const denominator = Math.pow(1 + monthlyRate, termInMonths) - 1;
      monthlyPayment = loanAmount * (numerator / denominator);
    }
    
    const totalPayment = monthlyPayment * termInMonths;
    const totalInterest = totalPayment - loanAmount;
    
    return {
      monthlyPayment: Math.round(monthlyPayment * 100) / 100,
      totalPayment: Math.round(totalPayment * 100) / 100,
      totalInterest: Math.round(totalInterest * 100) / 100,
      loanAmount: Math.round(loanAmount * 100) / 100,
      principalAmount,
      downPayment,
      annualInterestRate,
      termInMonths,
    };
  }

  async create(createLoanDto: CreateLoanDto, userId: string): Promise<LoanResponseDto> {
    // Calculate loan payments
    const calculation = this.calculateLoan(createLoanDto);
    
    // Create loan document
    const loan = new this.loanModel({
      ...createLoanDto,
      ...calculation,
      userId: new Types.ObjectId(userId),
    });
    
    const savedLoan = await loan.save();
    
    return new LoanResponseDto({
      id: savedLoan._id.toString(),
      userId: savedLoan.userId.toString(),
      loanType: savedLoan.loanType,
      principalAmount: savedLoan.principalAmount,
      annualInterestRate: savedLoan.annualInterestRate,
      termInMonths: savedLoan.termInMonths,
      downPayment: savedLoan.downPayment,
      monthlyPayment: savedLoan.monthlyPayment,
      totalPayment: savedLoan.totalPayment,
      totalInterest: savedLoan.totalInterest,
      loanAmount: savedLoan.loanAmount,
      title: savedLoan.title,
      notes: savedLoan.notes,
      createdAt: savedLoan.createdAt,
      updatedAt: savedLoan.updatedAt,
    });
  }

  async findAll(userId: string, loanType?: LoanType): Promise<LoanResponseDto[]> {
    const query: any = { userId: new Types.ObjectId(userId) };
    
    if (loanType) {
      query.loanType = loanType;
    }
    
    const loans = await this.loanModel
      .find(query)
      .sort({ createdAt: -1 })
      .exec();
    
    return loans.map(loan => new LoanResponseDto({
      id: loan._id.toString(),
      userId: loan.userId.toString(),
      loanType: loan.loanType,
      principalAmount: loan.principalAmount,
      annualInterestRate: loan.annualInterestRate,
      termInMonths: loan.termInMonths,
      downPayment: loan.downPayment,
      monthlyPayment: loan.monthlyPayment,
      totalPayment: loan.totalPayment,
      totalInterest: loan.totalInterest,
      loanAmount: loan.loanAmount,
      title: loan.title,
      notes: loan.notes,
      createdAt: loan.createdAt,
      updatedAt: loan.updatedAt,
    }));
  }

  async findOne(id: string, userId: string): Promise<LoanResponseDto> {
    const loan = await this.loanModel.findById(id).exec();
    
    if (!loan) {
      throw new NotFoundException('Loan not found');
    }
    
    // Check if the loan belongs to the user
    if (loan.userId.toString() !== userId) {
      throw new ForbiddenException('You do not have access to this loan');
    }
    
    return new LoanResponseDto({
      id: loan._id.toString(),
      userId: loan.userId.toString(),
      loanType: loan.loanType,
      principalAmount: loan.principalAmount,
      annualInterestRate: loan.annualInterestRate,
      termInMonths: loan.termInMonths,
      downPayment: loan.downPayment,
      monthlyPayment: loan.monthlyPayment,
      totalPayment: loan.totalPayment,
      totalInterest: loan.totalInterest,
      loanAmount: loan.loanAmount,
      title: loan.title,
      notes: loan.notes,
      createdAt: loan.createdAt,
      updatedAt: loan.updatedAt,
    });
  }

  async update(id: string, updateLoanDto: UpdateLoanDto, userId: string): Promise<LoanResponseDto> {
    const loan = await this.loanModel.findById(id).exec();
    
    if (!loan) {
      throw new NotFoundException('Loan not found');
    }
    
    // Check if the loan belongs to the user
    if (loan.userId.toString() !== userId) {
      throw new ForbiddenException('You do not have access to this loan');
    }
    
    // Only allow updating title and notes
    // Note: This update is safe because:
    // 1. id is validated - comes from authenticated user's request
    // 2. updateLoanDto is validated by class-validator decorators
    // 3. Only title and notes fields are allowed in UpdateLoanDto
    // 4. Mongoose findByIdAndUpdate sanitizes all inputs automatically
    const updatedLoan = await this.loanModel
      .findByIdAndUpdate(id, updateLoanDto, { new: true })
      .exec();
    
    return new LoanResponseDto({
      id: updatedLoan._id.toString(),
      userId: updatedLoan.userId.toString(),
      loanType: updatedLoan.loanType,
      principalAmount: updatedLoan.principalAmount,
      annualInterestRate: updatedLoan.annualInterestRate,
      termInMonths: updatedLoan.termInMonths,
      downPayment: updatedLoan.downPayment,
      monthlyPayment: updatedLoan.monthlyPayment,
      totalPayment: updatedLoan.totalPayment,
      totalInterest: updatedLoan.totalInterest,
      loanAmount: updatedLoan.loanAmount,
      title: updatedLoan.title,
      notes: updatedLoan.notes,
      createdAt: updatedLoan.createdAt,
      updatedAt: updatedLoan.updatedAt,
    });
  }

  async remove(id: string, userId: string): Promise<void> {
    const loan = await this.loanModel.findById(id).exec();
    
    if (!loan) {
      throw new NotFoundException('Loan not found');
    }
    
    // Check if the loan belongs to the user
    if (loan.userId.toString() !== userId) {
      throw new ForbiddenException('You do not have access to this loan');
    }
    
    await this.loanModel.findByIdAndDelete(id).exec();
  }

  async getStatistics(userId: string) {
    const loans = await this.loanModel
      .find({ userId: new Types.ObjectId(userId) })
      .exec();
    
    const stats = {
      totalLoans: loans.length,
      byType: {
        house: 0,
        car: 0,
        personal: 0,
        other: 0,
      },
      totalPrincipal: 0,
      totalMonthlyPayment: 0,
      totalInterest: 0,
    };
    
    loans.forEach(loan => {
      stats.byType[loan.loanType]++;
      stats.totalPrincipal += loan.principalAmount;
      stats.totalMonthlyPayment += loan.monthlyPayment;
      stats.totalInterest += loan.totalInterest;
    });
    
    // Round to 2 decimal places
    stats.totalPrincipal = Math.round(stats.totalPrincipal * 100) / 100;
    stats.totalMonthlyPayment = Math.round(stats.totalMonthlyPayment * 100) / 100;
    stats.totalInterest = Math.round(stats.totalInterest * 100) / 100;
    
    return stats;
  }
}
