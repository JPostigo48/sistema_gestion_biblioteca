import { Injectable } from '@nestjs/common';
import {
  LoanInventoryPort,
  type CopyLoanAvailability,
  type ReleaseCopyInput,
} from '../../application/ports/loan-inventory.port.js';
import { InventoryService } from '../../../inventory/application/use-cases/inventory.service.js';

@Injectable()
export class InventoryLoansAdapter implements LoanInventoryPort {
  constructor(private readonly inventory: InventoryService) {}

  async getAvailability(copyId: string): Promise<CopyLoanAvailability> {
    // TODO
    throw new Error('Not implemented');
  }

  async markAsLoaned(copyId: string): Promise<void> {
    // TODO
    throw new Error('Not implemented');
  }

  async releaseAfterReturn(input: ReleaseCopyInput): Promise<void> {
    // TODO
    throw new Error('Not implemented');
  }
}
