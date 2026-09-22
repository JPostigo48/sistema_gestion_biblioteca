import "dotenv/config";
import { Injectable, OnModuleDestroy, OnModuleInit } from "@nestjs/common";
import postgres from "@prisma/orm-postgres/runtime";
import type { Contract } from "./contract.d.ts";
import contractJson from "./contract.json" with { type: "json" };

@Injectable()
export class PrismaService implements OnModuleInit, OnModuleDestroy {
  readonly client = postgres<Contract>({
    contractJson,
    url: process.env.DATABASE_URL!,
  });

  get orm() {
    return this.client.orm;
  }

  get sql() {
    return this.client.sql;
  }

  get enums() {
    return this.client.enums;
  }

  async onModuleInit(): Promise<void> {
    await this.client.connect();
  }

  async onModuleDestroy(): Promise<void> {
    await this.client.close();
  }
}
