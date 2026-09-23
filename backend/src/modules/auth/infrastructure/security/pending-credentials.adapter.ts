import { Injectable } from '@nestjs/common';
import { CredentialsPort } from '../../application/ports/credentials.port.js';

@Injectable()
export class PendingCredentialsAdapter implements CredentialsPort {
  async hash(password: string): Promise<string> {
    // TODO
    throw new Error('Not implemented');
  }

  async matches(password: string, passwordHash: string): Promise<boolean> {
    // TODO
    throw new Error('Not implemented');
  }
}
