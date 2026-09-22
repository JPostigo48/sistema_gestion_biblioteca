import { Injectable } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.service.js";

@Injectable()
export class InventoryRepository {
  constructor(private readonly prisma: PrismaService) {}

  async listResources() {
    const query = this.prisma.sql.public.recursos
      .select(
        "id",
        "categoriaId",
        "nombre",
        "descripcion",
        "createdAt",
        "updatedAt",
      )
      .build();

    // Corregido para usar el runtime real de tu versión de Prisma 8
    const runtime = (this.prisma.client as any).runtime();
    return await runtime.query(query);
  }
}
