import { Controller, Get } from "@nestjs/common";
import { InventoryService } from "./inventory.service.js";

@Controller("inventory")
export class InventoryController {
  constructor(private readonly service: InventoryService) {}

  @Get("resources")
  listResources() {
    return this.service.listResources();
  }
}
