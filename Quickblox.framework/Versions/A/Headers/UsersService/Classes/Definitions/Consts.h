/*
 *  Consts.h
 *  Mobserv
 *

 *  Copyright 2011 Mob1serv team. All rights reserved.
 *
 */

extern NSString* const kUsersServiceException;
extern NSString* const kUsersServiceErrorDomain;

//Exceptions
extern NSString* const kUsersServiceExceptionUnknownOwnerType;

//Owner Types
extern NSString* const kUsersServiceUserOwnerTypeApplication;
extern NSString* const kUsersServiceUserOwnerTypeService;

#define EUS(B,C) E(kUsersServiceException, B,C)
#define EUS2(B) E2(kUsersServiceException, B)