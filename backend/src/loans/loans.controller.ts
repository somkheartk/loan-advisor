import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
  Request,
  Query,
} from '@nestjs/common';
import { LoansService } from './loans.service';
import { CreateLoanDto } from './dto/create-loan.dto';
import { UpdateLoanDto } from './dto/update-loan.dto';
import { CalculateLoanDto } from './dto/calculate-loan.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { LoanType } from './schemas/loan.schema';

@Controller('loans')
@UseGuards(JwtAuthGuard)
export class LoansController {
  constructor(private readonly loansService: LoansService) {}

  @Post('calculate')
  calculate(@Body() calculateLoanDto: CalculateLoanDto) {
    return this.loansService.calculateLoan(calculateLoanDto);
  }

  @Post()
  create(@Body() createLoanDto: CreateLoanDto, @Request() req) {
    return this.loansService.create(createLoanDto, req.user.userId);
  }

  @Get()
  findAll(@Request() req, @Query('type') loanType?: LoanType) {
    return this.loansService.findAll(req.user.userId, loanType);
  }

  @Get('statistics')
  getStatistics(@Request() req) {
    return this.loansService.getStatistics(req.user.userId);
  }

  @Get(':id')
  findOne(@Param('id') id: string, @Request() req) {
    return this.loansService.findOne(id, req.user.userId);
  }

  @Patch(':id')
  update(
    @Param('id') id: string,
    @Body() updateLoanDto: UpdateLoanDto,
    @Request() req,
  ) {
    return this.loansService.update(id, updateLoanDto, req.user.userId);
  }

  @Delete(':id')
  remove(@Param('id') id: string, @Request() req) {
    return this.loansService.remove(id, req.user.userId);
  }
}
