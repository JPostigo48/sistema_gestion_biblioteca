import { Module } from "@nestjs/common";
import { AppController } from "./app.controller.js";
import { AppService } from "./app.service.js";
import { PrismaModule } from "./prisma/prisma.module.js";
import { InventoryModule } from "./inventory/inventory.module.js";

@Module({
  imports: [PrismaModule, InventoryModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}

