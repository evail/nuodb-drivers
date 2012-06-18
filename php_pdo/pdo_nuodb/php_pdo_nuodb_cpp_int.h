/****************************************************************************
 * Copyright (c) 2012, NuoDB, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of NuoDB, Inc. nor the names of its contributors may
 *       be used to endorse or promote products derived from this software
 *       without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL NUODB, INC. BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 ****************************************************************************/

#ifndef PHP_PDO_NUODB_CPP_INT_H
#define PHP_PDO_NUODB_CPP_INT_H

#include "Connection.h"
#include "Properties.h"
#include "ResultSet.h"
#include "DatabaseMetaData.h"
#include "PreparedStatement.h"

struct SqlOption
{
    char const * option;
    void * extra;
};

struct SqlOptionArray
{
    size_t count;
    SqlOption const * array;
};

class PdoNuoDbStatement;

class PdoNuoDbHandle
{
private:
    NuoDB::Connection * _con;
    SqlOptionArray * _opts;
    SqlOption _opt_arr[4];
    PdoNuoDbStatement * _last_stmt;
    void deleteOptions();
public:
    PdoNuoDbHandle(SqlOptionArray * options);
    ~PdoNuoDbHandle();
    void setOptions(SqlOptionArray * options);
    NuoDB::Connection * createConnection();
    NuoDB::Connection * getConnection();
    PdoNuoDbStatement * createStatement(char const * sql);
    void closeConnection();
    void commit();
    void rollback();
};

class PdoNuoDbStatement
{
private:
    PdoNuoDbHandle * _dbh;
    NuoDB::PreparedStatement * _stmt;
    int _stmt_type; // 0=unknown, 1=select, 2=update
    NuoDB::ResultSet * _rs;
public:
    PdoNuoDbStatement(PdoNuoDbHandle * dbh);
    ~PdoNuoDbStatement();
    NuoDB::PreparedStatement * createStatement(char const * sql);
    void execute();
    void executeQuery();
    bool hasResultSet();
    bool next();
    size_t getColumnCount();
    char const * getColumnName(size_t column);
    int getSqlType(size_t column);
    char const * getString(size_t column);
    unsigned int getInteger(size_t column);
    unsigned long getLong(size_t column);
    unsigned long getTimestamp(size_t column);
    unsigned long getDate(size_t column);
    unsigned long getTime(size_t column);
    size_t getNumberOfParameters();

    void setInteger(size_t index, int value);
    void setString(size_t index, const char *value);

};

#endif	/* PHP_PDO_NUODB_INT_CPP_H */
