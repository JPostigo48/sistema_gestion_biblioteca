import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../../../shared/infrastructure/prisma/prisma.service.js';
import type {
  TermsAcceptance,
  TermsVersion,
} from '../../../domain/entities/terms.js';
import {
  TermsRepository,
  type AcceptTermsVersionData,
  type CreateTermsVersionData,
} from '../../../domain/repositories/terms.repository.js';

@Injectable()
export class PrismaTermsRepository implements TermsRepository {
  constructor(private readonly prisma: PrismaService) {}

  async createVersion(data: CreateTermsVersionData): Promise<TermsVersion> {
    // TODO
    throw new Error('Not implemented');
  }

  async findVersionById(versionId: string): Promise<TermsVersion | null> {
    // TODO
    throw new Error('Not implemented');
  }

  async accept(data: AcceptTermsVersionData): Promise<TermsAcceptance> {
    // TODO
    throw new Error('Not implemented');
  }

  async findAcceptancesByUserId(userId: string): Promise<TermsAcceptance[]> {
    // TODO
    throw new Error('Not implemented');
  }
}
