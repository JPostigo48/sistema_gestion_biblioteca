import { Injectable } from "@nestjs/common";
import { InventoryRepository } from "./repositories/inventory.repository.js";

@Injectable()
export class InventoryService {
  constructor(private readonly repository: InventoryRepository) {}

  listResources() {
    return this.repository.listResources();
  }
}
