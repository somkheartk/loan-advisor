export class AuthResponseDto {
  accessToken: string;
  user: {
    email: string;
    name: string;
  };

  constructor(partial: Partial<AuthResponseDto>) {
    Object.assign(this, partial);
  }
}
