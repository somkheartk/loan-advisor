export class UserResponseDto {
  email: string;
  name: string;
  isActive: boolean;
  createdAt?: Date;
  updatedAt?: Date;

  constructor(partial: Partial<UserResponseDto>) {
    Object.assign(this, partial);
  }
}
