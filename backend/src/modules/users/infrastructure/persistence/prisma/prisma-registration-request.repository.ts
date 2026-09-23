import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../../../shared/infrastructure/prisma/prisma.service.js';
import type {
  RegistrationRequest,
  RegistrationRequestStatus,
} from '../../../domain/entities/registration-request.js';
import {
  RegistrationRequestRepository,
  type CreateRegistrationRequestData,
} from '../../../domain/repositories/registration-request.repository.js';

@Injectable()
export class PrismaRegistrationRequestRepository extends RegistrationRequestRepository {
  constructor(private readonly prisma: PrismaService) {
    super();
  }

  async create(
    data: CreateRegistrationRequestData,
  ): Promise<RegistrationRequest> {
    // TODO
    throw new Error('Not implemented');
  }

  async findById(requestId: string): Promise<RegistrationRequest | null> {
    // TODO
    throw new Error('Not implemented');
  }

  async updateStatus(
    requestId: string,
    status: RegistrationRequestStatus,
    approvedUserId?: string,
  ): Promise<RegistrationRequest> {
    // TODO
    throw new Error('Not implemented');
  }
}
