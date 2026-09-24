enum UserRole { security, admin }

String roleLabel(UserRole r) => r == UserRole.admin ? 'Admin' : 'Security';
