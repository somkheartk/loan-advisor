import { Controller, Get } from '@nestjs/common';

@Controller()
export class AppController {
  @Get()
  getHello(): string {
    return 'Loan Advisor Backend API is running! 🚀';
  }

  @Get('health')
  healthCheck() {
    return {
      status: 'ok',
      timestamp: new Date().toISOString(),
      service: 'loan-advisor-backend',
      version: '1.0.0',
    };
  }
}
