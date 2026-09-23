import { Module } from '@nestjs/common';
import { AppController } from './app.controller.js';
import { AppService } from './app.service.js';
import { InventoryModule } from './modules/inventory/inventory.module.js';
import { PrismaModule } from './shared/infrastructure/prisma/prisma.module.js';

@Module({
  imports: [PrismaModule, InventoryModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
