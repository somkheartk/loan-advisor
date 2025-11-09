import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';

export type LoanDocument = Loan & Document;

export enum LoanType {
  HOUSE = 'house',
  CAR = 'car',
  PERSONAL = 'personal',
  OTHER = 'other',
}

@Schema({ timestamps: true })
export class Loan {
  @Prop({ required: true, type: Types.ObjectId, ref: 'User' })
  userId: Types.ObjectId;

  @Prop({ required: true, enum: Object.values(LoanType) })
  loanType: LoanType;

  @Prop({ required: true })
  principalAmount: number;

  @Prop({ required: true })
  annualInterestRate: number;

  @Prop({ required: true })
  termInMonths: number;

  @Prop()
  downPayment?: number;

  @Prop({ required: true })
  monthlyPayment: number;

  @Prop({ required: true })
  totalPayment: number;

  @Prop({ required: true })
  totalInterest: number;

  @Prop({ required: true })
  loanAmount: number;

  @Prop()
  title?: string;

  @Prop()
  notes?: string;

  @Prop()
  createdAt?: Date;

  @Prop()
  updatedAt?: Date;
}

export const LoanSchema = SchemaFactory.createForClass(Loan);

// Indexes for faster queries
LoanSchema.index({ userId: 1, createdAt: -1 });
LoanSchema.index({ userId: 1, loanType: 1 });
