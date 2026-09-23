import { Module } from '@nestjs/common';
import { AppController } from './app.controller.js';
import { AppService } from './app.service.js';
import { AuthModule } from './modules/auth/auth.module.js';
import { InventoryModule } from './modules/inventory/inventory.module.js';
import { LoansModule } from './modules/loans/loans.module.js';
import { UsersModule } from './modules/users/users.module.js';
import { PrismaModule } from './shared/infrastructure/prisma/prisma.module.js';

@Module({
  imports: [
    PrismaModule,
    InventoryModule,
    UsersModule,
    LoansModule,
    AuthModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
