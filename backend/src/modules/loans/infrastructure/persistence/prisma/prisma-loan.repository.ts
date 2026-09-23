import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../../../shared/infrastructure/prisma/prisma.service.js';
import type { Loan, LoanReturn } from '../../../domain/entities/loan.js';
import {
  LoanRepository,
  type CreateLoanData,
  type RegisterLoanReturnData,
} from '../../../domain/repositories/loan.repository.js';

@Injectable()
export class PrismaLoanRepository implements LoanRepository {
  constructor(private readonly prisma: PrismaService) {}

  async create(data: CreateLoanData): Promise<Loan> {
    // TODO
    throw new Error('Not implemented');
  }

  async findById(loanId: string): Promise<Loan | null> {
    // TODO
    throw new Error('Not implemented');
  }

  async findActive(): Promise<Loan[]> {
    // TODO
    throw new Error('Not implemented');
  }

  async findByUserId(userId: string): Promise<Loan[]> {
    // TODO
    throw new Error('Not implemented');
  }

  async findOverdue(at: Date): Promise<Loan[]> {
    // TODO
    throw new Error('Not implemented');
  }

  async hasOverlappingLoan(
    copyId: string,
    startsAt: Date,
    endsAt: Date,
  ): Promise<boolean> {
    // TODO
    throw new Error('Not implemented');
  }

  async registerReturn(data: RegisterLoanReturnData): Promise<LoanReturn> {
    // TODO
    throw new Error('Not implemented');
  }
}
