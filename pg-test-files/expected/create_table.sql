--
-- CREATE_TABLE
--
--
-- CLASS DEFINITIONS
--

CREATE TABLE hobbies_r (
    name text,
    person text
);

CREATE TABLE equipment_r (
    name text,
    hobby text
);

CREATE TABLE onek (
    unique1 int4,
    unique2 int4,
    two int4,
    four int4,
    ten int4,
    twenty int4,
    hundred int4,
    thousand int4,
    twothousand int4,
    fivethous int4,
    tenthous int4,
    odd int4,
    even int4,
    stringu1 name,
    stringu2 name,
    string4 name
);

CREATE TABLE tenk1 (
    unique1 int4,
    unique2 int4,
    two int4,
    four int4,
    ten int4,
    twenty int4,
    hundred int4,
    thousand int4,
    twothousand int4,
    fivethous int4,
    tenthous int4,
    odd int4,
    even int4,
    stringu1 name,
    stringu2 name,
    string4 name
);

CREATE TABLE tenk2 (
    unique1 int4,
    unique2 int4,
    two int4,
    four int4,
    ten int4,
    twenty int4,
    hundred int4,
    thousand int4,
    twothousand int4,
    fivethous int4,
    tenthous int4,
    odd int4,
    even int4,
    stringu1 name,
    stringu2 name,
    string4 name
);

CREATE TABLE person (
    name text,
    age int4,
    location point
);

CREATE TABLE emp (
    salary int4,
    manager name
)
INHERITS (
    person
);

CREATE TABLE student (
    gpa float8
)
INHERITS (
    person
);

CREATE TABLE stud_emp (
    percent int4
)
INHERITS (
    emp,
    student
);

CREATE TABLE city (
    name name,
    location box,
    budget city_budget
);

CREATE TABLE dept (
    dname name,
    mgrname text
);

CREATE TABLE slow_emp4000 (
    home_base box
);

CREATE TABLE fast_emp4000 (
    home_base box
);

CREATE TABLE road (
    name text,
    thepath path
);

CREATE TABLE ihighway ()
INHERITS (
    road
);

CREATE TABLE shighway (
    surface text
)
INHERITS (
    road
);

CREATE TABLE real_city (
    pop int4,
    cname text,
    outline path
);

--
-- test the "star" operators a bit more thoroughly -- this time,
-- throw in lots of NULL fields...
--
-- a is the type root
-- b and c inherit from a (one-level single inheritance)
-- d inherits from b and c (two-level multiple inheritance)
-- e inherits from c (two-level single inheritance)
-- f inherits from e (three-level single inheritance)
--

CREATE TABLE a_star (
    class char,
    a int4
);

CREATE TABLE b_star (
    b text
)
INHERITS (
    a_star
);

CREATE TABLE c_star (
    c name
)
INHERITS (
    a_star
);

CREATE TABLE d_star (
    d float8
)
INHERITS (
    b_star,
    c_star
);

CREATE TABLE e_star (
    e int2
)
INHERITS (
    c_star
);

CREATE TABLE f_star (
    f polygon
)
INHERITS (
    e_star
);

CREATE TABLE aggtest (
    a int2,
    b float4
);

CREATE TABLE hash_i4_heap (
    seqno int4,
    random int4
);

CREATE TABLE hash_name_heap (
    seqno int4,
    random name
);

CREATE TABLE hash_txt_heap (
    seqno int4,
    random text
);

CREATE TABLE hash_f8_heap (
    seqno int4,
    random float8
);

-- don't include the hash_ovfl_heap stuff in the distribution
-- the data set is too large for what it's worth
--
-- CREATE TABLE hash_ovfl_heap (
--	x			int4,
--	y			int4
-- );

CREATE TABLE bt_i4_heap (
    seqno int4,
    random int4
);

CREATE TABLE bt_name_heap (
    seqno name,
    random int4
);

CREATE TABLE bt_txt_heap (
    seqno text,
    random int4
);

CREATE TABLE bt_f8_heap (
    seqno float8,
    random int4
);

CREATE TABLE array_op_test (
    seqno int4,
    i int4[],
    t text[]
);

CREATE TABLE array_index_op_test (
    seqno int4,
    i int4[],
    t text[]
);

CREATE TABLE testjsonb (
    j jsonb
);

CREATE TABLE unknowntab (
    u unknown -- fail
);

CREATE TYPE unknown_comptype AS (
    u unknown -- fail
);

CREATE TABLE IF NOT EXISTS test_tsvector (
    t text,
    a tsvector
);

CREATE TABLE IF NOT EXISTS test_tsvector (
    t text
);

-- invalid: non-lowercase quoted reloptions identifiers
CREATE TABLE tas_case WITH (
    "Fillfactor" = 10
) AS
SELECT
    1 a;

CREATE UNLOGGED TABLE unlogged1 (
    a int PRIMARY KEY
);

-- OK
CREATE TEMPORARY TABLE unlogged2 (
    a int PRIMARY KEY
);

-- OK
SELECT
    relname,
    relkind,
    relpersistence
FROM
    pg_class
WHERE
    relname ~ '^unlogged\d'
ORDER BY
    relname;

REINDEX INDEX unlogged1_pkey;

REINDEX INDEX unlogged2_pkey;

SELECT
    relname,
    relkind,
    relpersistence
FROM
    pg_class
WHERE
    relname ~ '^unlogged\d'
ORDER BY
    relname;

DROP TABLE unlogged2;

INSERT INTO unlogged1
    VALUES (42);

CREATE UNLOGGED TABLE public.unlogged2 (
    a int PRIMARY KEY
);

-- also OK
CREATE UNLOGGED TABLE pg_temp.unlogged3 (
    a int PRIMARY KEY
);

-- not OK
CREATE TABLE pg_temp.implicitly_temp (
    a int PRIMARY KEY
);

-- OK
CREATE TEMP TABLE explicitly_temp (
    a int PRIMARY KEY
);

-- also OK
CREATE TEMP TABLE pg_temp.doubly_temp (
    a int PRIMARY KEY
);

-- also OK
CREATE TEMP TABLE public.temp_to_perm (
    a int PRIMARY KEY
);

-- not OK
DROP TABLE unlogged1, public.unlogged2;

CREATE TABLE as_select1 AS
SELECT
    *
FROM
    pg_class
WHERE
    relkind = 'r';

CREATE TABLE as_select1 AS
SELECT
    *
FROM
    pg_class
WHERE
    relkind = 'r';

CREATE TABLE IF NOT EXISTS as_select1 AS
    SELECT
        *
    FROM
        pg_class
    WHERE
        relkind = 'r';

DROP TABLE as_select1;

PREPARE select1 AS
SELECT
    1 AS a;

CREATE TABLE as_select1 AS
EXECUTE select1;

CREATE TABLE as_select1 AS
EXECUTE select1;

SELECT
    *
FROM
    as_select1;

CREATE TABLE IF NOT EXISTS as_select1 AS
    EXECUTE select1;

DROP TABLE as_select1;

DEALLOCATE select1;

-- create an extra wide table to test for issues related to that
-- (temporarily hide query, to avoid the long CREATE TABLE stmt)

\set ECHO none
SELECT
    'CREATE TABLE extra_wide_table(firstc text, ' || array_to_string(array_agg('c' || i || ' bool'), ',') || ', lastc text);'
FROM
    generate_series(1, 1100) g (i) \gexec

\set ECHO all
INSERT INTO extra_wide_table (firstc, lastc)
    VALUES ('first col', 'last col');

SELECT
    firstc,
    lastc
FROM
    extra_wide_table;

-- check that tables with oids cannot be created anymore
CREATE TABLE withoid (
)
WITH OIDS;

CREATE TABLE withoid (
)
WITH (
    OIDS
);

CREATE TABLE withoid (
)
WITH (
    OIDS = TRUE
);

-- but explicitly not adding oids is still supported
CREATE TEMP TABLE withoutoid () WITHOUT OIDS;

DROP TABLE withoutoid;

CREATE TEMP TABLE withoutoid (
)
WITH (
    OIDS = FALSE
);

DROP TABLE withoutoid;

-- check restriction with default expressions
-- invalid use of column reference in default expressions

CREATE TABLE default_expr_column (
    id int DEFAULT (id)
);

CREATE TABLE default_expr_column (
    id int DEFAULT (bar.id)
);

CREATE TABLE default_expr_agg_column (
    id int DEFAULT (avg(id))
);

-- invalid column definition
CREATE TABLE default_expr_non_column (
    a int DEFAULT (avg(non_existent))
);

-- invalid use of aggregate
CREATE TABLE default_expr_agg (
    a int DEFAULT (avg(1))
);

-- invalid use of subquery
CREATE TABLE default_expr_agg (
    a int DEFAULT (
    SELECT
        1)
);

-- invalid use of set-returning function
CREATE TABLE default_expr_agg (
    a int DEFAULT (generate_series(1, 3))
);

--
-- Partitioned tables
--
-- cannot combine INHERITS and PARTITION BY (although grammar allows)

CREATE TABLE partitioned (
    a int
)
INHERITS (
    some_table
)
PARTITION BY LIST (a);

-- cannot use more than 1 column as partition key for list partitioned table
CREATE TABLE partitioned (
    a1 int,
    a2 int
)
PARTITION BY LIST (a1, a2);

-- fail
-- unsupported constraint type for partitioned tables

CREATE TABLE partitioned (
    a int,
    EXCLUDE USING gist (a WITH &&)
)
PARTITION BY RANGE (a);

-- prevent using prohibited expressions in the key
CREATE FUNCTION retset (a int)
    RETURNS SETOF int
    AS $$
    SELECT
        1;

$$
LANGUAGE SQL
IMMUTABLE;

CREATE TABLE partitioned (
    a int
)
PARTITION BY RANGE (retset (a));

DROP FUNCTION retset (int);

CREATE TABLE partitioned (
    a int
)
PARTITION BY RANGE ((avg(a)));

CREATE TABLE partitioned (
    a int,
    b int
)
PARTITION BY RANGE ((avg(a) OVER (PARTITION BY b)));

CREATE TABLE partitioned (
    a int
)
PARTITION BY LIST ((a LIKE (
SELECT
    1)));

CREATE TABLE partitioned (
    a int
)
PARTITION BY RANGE (('a'));

CREATE FUNCTION const_func ()
    RETURNS int
    AS $$
    SELECT
        1;

$$
LANGUAGE SQL
IMMUTABLE;

CREATE TABLE partitioned (
    a int
)
PARTITION BY RANGE (const_func ());

DROP FUNCTION const_func ();

-- only accept valid partitioning strategy
CREATE TABLE partitioned (
    a int
)
PARTITION BY MAGIC (a);

-- specified column must be present in the table
CREATE TABLE partitioned (
    a int
)
PARTITION BY RANGE (b);

-- cannot use system columns in partition key
CREATE TABLE partitioned (
    a int
)
PARTITION BY RANGE (xmin);

-- functions in key must be immutable
CREATE FUNCTION immut_func (a int)
    RETURNS int
    AS $$
    SELECT
        a + random()::int;

$$
LANGUAGE SQL;

CREATE TABLE partitioned (
    a int
)
PARTITION BY RANGE (immut_func (a));

DROP FUNCTION immut_func (int);

-- cannot contain whole-row references
CREATE TABLE partitioned (
    a int
)
PARTITION BY RANGE ((partitioned));

-- prevent using columns of unsupported types in key (type must have a btree operator class)
CREATE TABLE partitioned (
    a point
)
PARTITION BY LIST (a);

CREATE TABLE partitioned (
    a point
)
PARTITION BY LIST (a point_ops);

CREATE TABLE partitioned (
    a point
)
PARTITION BY RANGE (a);

CREATE TABLE partitioned (
    a point
)
PARTITION BY RANGE (a point_ops);

-- cannot add NO INHERIT constraints to partitioned tables
CREATE TABLE partitioned (
    a int,
    CONSTRAINT check_a CHECK (a > 0) NO INHERIT
)
PARTITION BY RANGE (a);

-- some checks after successful creation of a partitioned table
CREATE FUNCTION plusone (a int)
    RETURNS INT
    AS $$
    SELECT
        a + 1;

$$
LANGUAGE SQL;

CREATE TABLE partitioned (
    a int,
    b int,
    c text,
    d text
)
PARTITION BY RANGE (a oid_ops, plusone (b), c COLLATE "default", d COLLATE "C");

-- check relkind
SELECT
    relkind
FROM
    pg_class
WHERE
    relname = 'partitioned';

-- prevent a function referenced in partition key from being dropped
DROP FUNCTION plusone (int);

-- partitioned table cannot participate in regular inheritance
CREATE TABLE partitioned2 (
    a int,
    b text
)
PARTITION BY RANGE ((a + 1), substr(b, 1, 5));

CREATE TABLE fail ()
INHERITS (
    partitioned2
);

-- Partition key in describe output
\d partitioned
\d+ partitioned2
INSERT INTO partitioned2
    VALUES (1, 'hello');

CREATE TABLE part2_1 PARTITION OF partitioned2
FOR VALUES FROM (- 1, 'aaaaa') TO (100, 'ccccc');

\d+ part2_1
DROP TABLE partitioned, partitioned2;

--
-- Partitions
--
-- check partition bound syntax

CREATE TABLE list_parted (
    a int
)
PARTITION BY LIST (a);

CREATE TABLE part_p1 PARTITION OF list_parted
FOR VALUES IN ('1');

CREATE TABLE part_p2 PARTITION OF list_parted
FOR VALUES IN (2);

CREATE TABLE part_p3 PARTITION OF list_parted
FOR VALUES IN ((2 + 1));

CREATE TABLE part_null PARTITION OF list_parted
FOR VALUES IN (NULL);

\d+ list_parted
-- forbidden expressions for partition bound with list partitioned table
CREATE TABLE part_bogus_expr_fail PARTITION OF list_parted
FOR VALUES IN (somename);

CREATE TABLE part_bogus_expr_fail PARTITION OF list_parted
FOR VALUES IN (somename.somename);

CREATE TABLE part_bogus_expr_fail PARTITION OF list_parted
FOR VALUES IN (a);

CREATE TABLE part_bogus_expr_fail PARTITION OF list_parted
FOR VALUES IN (sum(a));

CREATE TABLE part_bogus_expr_fail PARTITION OF list_parted
FOR VALUES IN (sum(somename));

CREATE TABLE part_bogus_expr_fail PARTITION OF list_parted
FOR VALUES IN (sum(1));

CREATE TABLE part_bogus_expr_fail PARTITION OF list_parted
FOR VALUES IN ((
SELECT
    1));

CREATE TABLE part_bogus_expr_fail PARTITION OF list_parted
FOR VALUES IN (generate_series(4, 6));

-- syntax does not allow empty list of values for list partitions
CREATE TABLE fail_part PARTITION OF list_parted
FOR VALUES IN ();

-- trying to specify range for list partitioned table
CREATE TABLE fail_part PARTITION OF list_parted
FOR VALUES FROM (1) TO (2);

-- trying to specify modulus and remainder for list partitioned table
CREATE TABLE fail_part PARTITION OF list_parted
FOR VALUES WITH (MODULUS 10, REMAINDER 1);

-- check default partition cannot be created more than once
CREATE TABLE part_default PARTITION OF list_parted DEFAULT;

CREATE TABLE fail_default_part PARTITION OF list_parted DEFAULT;

-- specified literal can't be cast to the partition column data type
CREATE TABLE bools (
    a bool
)
PARTITION BY LIST (a);

CREATE TABLE bools_true PARTITION OF bools
FOR VALUES IN (1);

DROP TABLE bools;

-- specified literal can be cast, and the cast might not be immutable
CREATE TABLE moneyp (
    a money
)
PARTITION BY LIST (a);

CREATE TABLE moneyp_10 PARTITION OF moneyp
FOR VALUES IN (10);

CREATE TABLE moneyp_11 PARTITION OF moneyp
FOR VALUES IN ('11');

CREATE TABLE moneyp_12 PARTITION OF moneyp
FOR VALUES IN (to_char(12, '99')::int);

DROP TABLE moneyp;

-- cast is immutable
CREATE TABLE bigintp (
    a bigint
)
PARTITION BY LIST (a);

CREATE TABLE bigintp_10 PARTITION OF bigintp
FOR VALUES IN (10);

-- fails due to overlap:
CREATE TABLE bigintp_10_2 PARTITION OF bigintp
FOR VALUES IN ('10');

DROP TABLE bigintp;

CREATE TABLE range_parted (
    a date
)
PARTITION BY RANGE (a);

-- forbidden expressions for partition bounds with range partitioned table
CREATE TABLE part_bogus_expr_fail PARTITION OF range_parted
FOR VALUES FROM (somename) TO ('2019-01-01');

CREATE TABLE part_bogus_expr_fail PARTITION OF range_parted
FOR VALUES FROM (somename.somename) TO ('2019-01-01');

CREATE TABLE part_bogus_expr_fail PARTITION OF range_parted
FOR VALUES FROM (a) TO ('2019-01-01');

CREATE TABLE part_bogus_expr_fail PARTITION OF range_parted
FOR VALUES FROM (max(a)) TO ('2019-01-01');

CREATE TABLE part_bogus_expr_fail PARTITION OF range_parted
FOR VALUES FROM (max(somename)) TO ('2019-01-01');

CREATE TABLE part_bogus_expr_fail PARTITION OF range_parted
FOR VALUES FROM (max('2019-02-01'::date)) TO ('2019-01-01');

CREATE TABLE part_bogus_expr_fail PARTITION OF range_parted
FOR VALUES FROM ((
SELECT
    1)) TO ('2019-01-01');

CREATE TABLE part_bogus_expr_fail PARTITION OF range_parted
FOR VALUES FROM (generate_series(1, 3)) TO ('2019-01-01');

-- trying to specify list for range partitioned table
CREATE TABLE fail_part PARTITION OF range_parted
FOR VALUES IN ('a');

-- trying to specify modulus and remainder for range partitioned table
CREATE TABLE fail_part PARTITION OF range_parted
FOR VALUES WITH (MODULUS 10, REMAINDER 1);

-- each of start and end bounds must have same number of values as the
-- length of the partition key

CREATE TABLE fail_part PARTITION OF range_parted
FOR VALUES FROM ('a', 1) TO ('z');

CREATE TABLE fail_part PARTITION OF range_parted
FOR VALUES FROM ('a') TO ('z', 1);

-- cannot specify null values in range bounds
CREATE TABLE fail_part PARTITION OF range_parted
FOR VALUES FROM (NULL) TO (MAXVALUE);

-- trying to specify modulus and remainder for range partitioned table
CREATE TABLE fail_part PARTITION OF range_parted
FOR VALUES WITH (MODULUS 10, REMAINDER 1);

-- check partition bound syntax for the hash partition
CREATE TABLE hash_parted (
    a int
)
PARTITION BY HASH (a);

CREATE TABLE hpart_1 PARTITION OF hash_parted
FOR VALUES WITH (MODULUS 10, REMAINDER 0);

CREATE TABLE hpart_2 PARTITION OF hash_parted
FOR VALUES WITH (MODULUS 50, REMAINDER 1);

CREATE TABLE hpart_3 PARTITION OF hash_parted
FOR VALUES WITH (MODULUS 200, REMAINDER 2);

-- modulus 25 is factor of modulus of 50 but 10 is not factor of 25.
CREATE TABLE fail_part PARTITION OF hash_parted
FOR VALUES WITH (MODULUS 25, REMAINDER 3);

-- previous modulus 50 is factor of 150 but this modulus is not factor of next modulus 200.
CREATE TABLE fail_part PARTITION OF hash_parted
FOR VALUES WITH (MODULUS 150, REMAINDER 3);

-- trying to specify range for the hash partitioned table
CREATE TABLE fail_part PARTITION OF hash_parted
FOR VALUES FROM ('a', 1) TO ('z');

-- trying to specify list value for the hash partitioned table
CREATE TABLE fail_part PARTITION OF hash_parted
FOR VALUES IN (1000);

-- trying to create default partition for the hash partitioned table
CREATE TABLE fail_default_part PARTITION OF hash_parted DEFAULT;

-- check if compatible with the specified parent
-- cannot create as partition of a non-partitioned table

CREATE TABLE unparted (
    a int
);

CREATE TABLE fail_part PARTITION OF unparted
FOR VALUES IN ('a');

CREATE TABLE fail_part PARTITION OF unparted
FOR VALUES WITH (MODULUS 2, REMAINDER 1);

DROP TABLE unparted;

-- cannot create a permanent rel as partition of a temp rel
CREATE TEMP TABLE temp_parted (
    a int
)
PARTITION BY LIST (a);

CREATE TABLE fail_part PARTITION OF temp_parted
FOR VALUES IN ('a');

DROP TABLE temp_parted;

-- check for partition bound overlap and other invalid specifications
CREATE TABLE list_parted2 (
    a varchar
)
PARTITION BY LIST (a);

CREATE TABLE part_null_z PARTITION OF list_parted2
FOR VALUES IN (NULL, 'z');

CREATE TABLE part_ab PARTITION OF list_parted2
FOR VALUES IN ('a', 'b');

CREATE TABLE list_parted2_def PARTITION OF list_parted2 DEFAULT;

CREATE TABLE fail_part PARTITION OF list_parted2
FOR VALUES IN (NULL);

CREATE TABLE fail_part PARTITION OF list_parted2
FOR VALUES IN ('b', 'c');

-- check default partition overlap
INSERT INTO list_parted2
    VALUES ('X');

CREATE TABLE fail_part PARTITION OF list_parted2
FOR VALUES IN ('W', 'X', 'Y');

CREATE TABLE range_parted2 (
    a int
)
PARTITION BY RANGE (a);

-- trying to create range partition with empty range
CREATE TABLE fail_part PARTITION OF range_parted2
FOR VALUES FROM (1) TO (0);

-- note that the range '[1, 1)' has no elements
CREATE TABLE fail_part PARTITION OF range_parted2
FOR VALUES FROM (1) TO (1);

CREATE TABLE part0 PARTITION OF range_parted2
FOR VALUES FROM (MINVALUE) TO (1);

CREATE TABLE fail_part PARTITION OF range_parted2
FOR VALUES FROM (MINVALUE) TO (2);

CREATE TABLE part1 PARTITION OF range_parted2
FOR VALUES FROM (1) TO (10);

CREATE TABLE fail_part PARTITION OF range_parted2
FOR VALUES FROM (9) TO (MAXVALUE);

CREATE TABLE part2 PARTITION OF range_parted2
FOR VALUES FROM (20) TO (30);

CREATE TABLE part3 PARTITION OF range_parted2
FOR VALUES FROM (30) TO (40);

CREATE TABLE fail_part PARTITION OF range_parted2
FOR VALUES FROM (10) TO (30);

CREATE TABLE fail_part PARTITION OF range_parted2
FOR VALUES FROM (10) TO (50);

-- Create a default partition for range partitioned table
CREATE TABLE range2_default PARTITION OF range_parted2 DEFAULT;

-- More than one default partition is not allowed, so this should give error
CREATE TABLE fail_default_part PARTITION OF range_parted2 DEFAULT;

-- Check if the range for default partitions overlap
INSERT INTO range_parted2
    VALUES (85);

CREATE TABLE fail_part PARTITION OF range_parted2
FOR VALUES FROM (80) TO (90);

CREATE TABLE part4 PARTITION OF range_parted2
FOR VALUES FROM (90) TO (100);

-- now check for multi-column range partition key
CREATE TABLE range_parted3 (
    a int,
    b int
)
PARTITION BY RANGE (a, (b + 1));

CREATE TABLE part00 PARTITION OF range_parted3
FOR VALUES FROM (0,
MINVALUE) TO (0,
MAXVALUE);

CREATE TABLE fail_part PARTITION OF range_parted3
FOR VALUES FROM (0,
MINVALUE) TO (0, 1);

CREATE TABLE part10 PARTITION OF range_parted3
FOR VALUES FROM (1,
MINVALUE) TO (1, 1);

CREATE TABLE part11 PARTITION OF range_parted3
FOR VALUES FROM (1, 1) TO (1, 10);

CREATE TABLE part12 PARTITION OF range_parted3
FOR VALUES FROM (1, 10) TO (1,
MAXVALUE);

CREATE TABLE fail_part PARTITION OF range_parted3
FOR VALUES FROM (1, 10) TO (1, 20);

CREATE TABLE range3_default PARTITION OF range_parted3 DEFAULT;

-- cannot create a partition that says column b is allowed to range
-- from -infinity to +infinity, while there exist partitions that have
-- more specific ranges

CREATE TABLE fail_part PARTITION OF range_parted3
FOR VALUES FROM (1,
MINVALUE) TO (1,
MAXVALUE);

-- check for partition bound overlap and other invalid specifications for the hash partition
CREATE TABLE hash_parted2 (
    a varchar
)
PARTITION BY HASH (a);

CREATE TABLE h2part_1 PARTITION OF hash_parted2
FOR VALUES WITH (MODULUS 4, REMAINDER 2);

CREATE TABLE h2part_2 PARTITION OF hash_parted2
FOR VALUES WITH (MODULUS 8, REMAINDER 0);

CREATE TABLE h2part_3 PARTITION OF hash_parted2
FOR VALUES WITH (MODULUS 8, REMAINDER 4);

CREATE TABLE h2part_4 PARTITION OF hash_parted2
FOR VALUES WITH (MODULUS 8, REMAINDER 5);

-- overlap with part_4
CREATE TABLE fail_part PARTITION OF hash_parted2
FOR VALUES WITH (MODULUS 2, REMAINDER 1);

-- modulus must be greater than zero
CREATE TABLE fail_part PARTITION OF hash_parted2
FOR VALUES WITH (MODULUS 0, REMAINDER 1);

-- remainder must be greater than or equal to zero and less than modulus
CREATE TABLE fail_part PARTITION OF hash_parted2
FOR VALUES WITH (MODULUS 8, REMAINDER 8);

-- check schema propagation from parent
CREATE TABLE parted (
    a text,
    b int NOT NULL DEFAULT 0,
    CONSTRAINT check_a CHECK (length(a) > 0)
)
PARTITION BY LIST (a);

CREATE TABLE part_a PARTITION OF parted
FOR VALUES IN ('a');

-- only inherited attributes (never local ones)
SELECT
    attname,
    attislocal,
    attinhcount
FROM
    pg_attribute
WHERE
    attrelid = 'part_a'::regclass
    AND attnum > 0
ORDER BY
    attnum;

-- able to specify column default, column constraint, and table constraint
-- first check the "column specified more than once" error

CREATE TABLE part_b PARTITION OF parted (b NOT NULL, b DEFAULT 1, b CHECK (b >= 0), CONSTRAINT check_a CHECK (length(a) > 0))
FOR VALUES IN ('b');

CREATE TABLE part_b PARTITION OF parted (b NOT NULL DEFAULT 1, CONSTRAINT check_a CHECK (length(a) > 0), CONSTRAINT check_b CHECK (b >= 0))
FOR VALUES IN ('b');

-- conislocal should be false for any merged constraints, true otherwise
SELECT
    conislocal,
    coninhcount
FROM
    pg_constraint
WHERE
    conrelid = 'part_b'::regclass
ORDER BY
    conislocal,
    coninhcount;

-- Once check_b is added to the parent, it should be made non-local for part_b
ALTER TABLE parted
    ADD CONSTRAINT check_b CHECK (b >= 0);

SELECT
    conislocal,
    coninhcount
FROM
    pg_constraint
WHERE
    conrelid = 'part_b'::regclass;

-- Neither check_a nor check_b are droppable from part_b
ALTER TABLE part_b
    DROP CONSTRAINT check_a;

ALTER TABLE part_b
    DROP CONSTRAINT check_b;

-- And dropping it from parted should leave no trace of them on part_b, unlike
-- traditional inheritance where they will be left behind, because they would
-- be local constraints.

ALTER TABLE parted
    DROP CONSTRAINT check_a,
    DROP CONSTRAINT check_b;

SELECT
    conislocal,
    coninhcount
FROM
    pg_constraint
WHERE
    conrelid = 'part_b'::regclass;

-- specify PARTITION BY for a partition
CREATE TABLE fail_part_col_not_found PARTITION OF parted
FOR VALUES IN ('c')
PARTITION BY RANGE (c);

CREATE TABLE part_c PARTITION OF parted (b WITH OPTIONS NOT NULL DEFAULT 0)
FOR VALUES IN ('c')
PARTITION BY RANGE ((b));

-- create a level-2 partition
CREATE TABLE part_c_1_10 PARTITION OF part_c
FOR VALUES FROM (1) TO (10);

-- check that NOT NULL and default value are inherited correctly
CREATE TABLE parted_notnull_inh_test (
    a int DEFAULT 1,
    b int NOT NULL DEFAULT 0
)
PARTITION BY LIST (a);

CREATE TABLE parted_notnull_inh_test1 PARTITION OF parted_notnull_inh_test (a NOT NULL, b DEFAULT 1)
FOR VALUES IN (1);

INSERT INTO parted_notnull_inh_test (b)
    VALUES (NULL);

-- note that while b's default is overriden, a's default is preserved
\d parted_notnull_inh_test1
DROP TABLE parted_notnull_inh_test;

-- check for a conflicting COLLATE clause
CREATE TABLE parted_collate_must_match (
    a text COLLATE "C",
    b text COLLATE "C"
)
PARTITION BY RANGE (a);

-- on the partition key
CREATE TABLE parted_collate_must_match1 PARTITION OF parted_collate_must_match (a COLLATE "POSIX")
FOR VALUES FROM ('a') TO ('m');

-- on another column
CREATE TABLE parted_collate_must_match2 PARTITION OF parted_collate_must_match (b COLLATE "POSIX")
FOR VALUES FROM ('m') TO ('z');

DROP TABLE parted_collate_must_match;

-- check that specifying incompatible collations for partition bound
-- expressions fails promptly

CREATE TABLE test_part_coll_posix (
    a text
)
PARTITION BY RANGE (a COLLATE "POSIX");

-- fail
CREATE TABLE test_part_coll PARTITION OF test_part_coll_posix
FOR VALUES FROM ('a' COLLATE "C") TO ('g');

-- ok
CREATE TABLE test_part_coll PARTITION OF test_part_coll_posix
FOR VALUES FROM ('a' COLLATE "POSIX") TO ('g');

-- ok
CREATE TABLE test_part_coll2 PARTITION OF test_part_coll_posix
FOR VALUES FROM ('g') TO ('m');

-- using a cast expression uses the target type's default collation
-- fail

CREATE TABLE test_part_coll_cast PARTITION OF test_part_coll_posix
FOR VALUES FROM (name 'm' COLLATE "C") TO ('s');

-- ok
CREATE TABLE test_part_coll_cast PARTITION OF test_part_coll_posix
FOR VALUES FROM (name 'm' COLLATE "POSIX") TO ('s');

-- ok; partition collation silently overrides the default collation of type 'name'
CREATE TABLE test_part_coll_cast2 PARTITION OF test_part_coll_posix
FOR VALUES FROM (name 's') TO ('z');

DROP TABLE test_part_coll_posix;

-- Partition bound in describe output
\d+ part_b
-- Both partition bound and partition key in describe output
\d+ part_c
-- a level-2 partition's constraint will include the parent's expressions
\d+ part_c_1_10
-- Show partition count in the parent's describe output
-- Tempted to include \d+ output listing partitions with bound info but
-- output could vary depending on the order in which partition oids are
-- returned.

\d parted
\d hash_parted
-- check that we get the expected partition constraints
CREATE TABLE range_parted4 (
    a int,
    b int,
    c int
)
PARTITION BY RANGE (abs(a), abs(b), c);

CREATE TABLE unbounded_range_part PARTITION OF range_parted4
FOR VALUES FROM (MINVALUE,
MINVALUE,
MINVALUE) TO (MAXVALUE,
MAXVALUE,
MAXVALUE);

\d+ unbounded_range_part
DROP TABLE unbounded_range_part;

CREATE TABLE range_parted4_1 PARTITION OF range_parted4
FOR VALUES FROM (MINVALUE,
MINVALUE,
MINVALUE) TO (1,
MAXVALUE,
MAXVALUE);

\d+ range_parted4_1
CREATE TABLE range_parted4_2 PARTITION OF range_parted4
FOR VALUES FROM (3, 4, 5) TO (6, 7,
MAXVALUE);

\d+ range_parted4_2
CREATE TABLE range_parted4_3 PARTITION OF range_parted4
FOR VALUES FROM (6, 8,
MINVALUE) TO (9,
MAXVALUE,
MAXVALUE);

\d+ range_parted4_3
DROP TABLE range_parted4;

-- user-defined operator class in partition key
CREATE FUNCTION my_int4_sort (int4, int4)
    RETURNS int
    LANGUAGE sql
    AS $$
    SELECT
        CASE WHEN $1 = $2 THEN
            0
        WHEN $1 > $2 THEN
            1
        ELSE
            - 1
        END;

$$;

CREATE OPERATOR CLASS test_int4_ops FOR TYPE int4
    USING btree AS
    OPERATOR 1 < (int4, int4),
    OPERATOR 2 <= (int4, int4),
    OPERATOR 3 = (int4, int4),
    OPERATOR 4 >= (int4, int4),
    OPERATOR 5 > (int4, int4),
    FUNCTION 1 my_int4_sort (int4, int4
);

CREATE TABLE partkey_t (
    a int4
)
PARTITION BY RANGE (a test_int4_ops);

CREATE TABLE partkey_t_1 PARTITION OF partkey_t
FOR VALUES FROM (0) TO (1000);

INSERT INTO partkey_t
    VALUES (100);

INSERT INTO partkey_t
    VALUES (200);

-- cleanup
DROP TABLE parted, list_parted, range_parted, list_parted2, range_parted2, range_parted3;

DROP TABLE partkey_t, hash_parted, hash_parted2;

DROP OPERATOR CLASS test_int4_ops
    USING btree;

DROP FUNCTION my_int4_sort (int4, int4);

-- comments on partitioned tables columns
CREATE TABLE parted_col_comment (
    a int,
    b text
)
PARTITION BY LIST (a);

COMMENT ON TABLE parted_col_comment IS 'Am partitioned table';

COMMENT ON COLUMN parted_col_comment.a IS 'Partition key';

SELECT
    obj_description('parted_col_comment'::regclass);

\d+ parted_col_comment
DROP TABLE parted_col_comment;

-- list partitioning on array type column
CREATE TABLE arrlp (
    a int[]
)
PARTITION BY LIST (a);

CREATE TABLE arrlp12 PARTITION OF arrlp
FOR VALUES IN ('{1}', '{2}');

\d+ arrlp12
DROP TABLE arrlp;

-- partition on boolean column
CREATE TABLE boolspart (
    a bool
)
PARTITION BY LIST (a);

CREATE TABLE boolspart_t PARTITION OF boolspart
FOR VALUES IN (TRUE);

CREATE TABLE boolspart_f PARTITION OF boolspart
FOR VALUES IN (FALSE);

\d+ boolspart
DROP TABLE boolspart;

-- partitions mixing temporary and permanent relations
CREATE TABLE perm_parted (
    a int
)
PARTITION BY LIST (a);

CREATE TEMPORARY TABLE temp_parted (
    a int
)
PARTITION BY LIST (a);

CREATE TABLE perm_part PARTITION OF temp_parted DEFAULT;

-- error
CREATE temp TABLE temp_part PARTITION OF perm_parted DEFAULT;

-- error
CREATE temp TABLE temp_part PARTITION OF temp_parted DEFAULT;

-- ok
DROP TABLE perm_parted CASCADE;

DROP TABLE temp_parted CASCADE;

-- check that adding partitions to a table while it is being used is prevented
CREATE TABLE tab_part_create (
    a int
)
PARTITION BY LIST (a);

CREATE OR REPLACE FUNCTION func_part_create ()
    RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
BEGIN
    EXECUTE 'create table tab_part_create_1 partition of tab_part_create for values in (1)';
    RETURN NULL;
END
$$;

CREATE TRIGGER trig_part_create
    BEFORE INSERT ON tab_part_create FOR EACH statement
    EXECUTE PROCEDURE func_part_create ();

INSERT INTO tab_part_create
    VALUES (1);

DROP TABLE tab_part_create;

DROP FUNCTION func_part_create ();

-- test using a volatile expression as partition bound
CREATE TABLE volatile_partbound_test (
    partkey timestamp
)
PARTITION BY RANGE (partkey);

CREATE TABLE volatile_partbound_test1 PARTITION OF volatile_partbound_test
FOR VALUES FROM (MINVALUE) TO (CURRENT_TIMESTAMP);

CREATE TABLE volatile_partbound_test2 PARTITION OF volatile_partbound_test
FOR VALUES FROM (CURRENT_TIMESTAMP) TO (MAXVALUE);

-- this should go into the partition volatile_partbound_test2
INSERT INTO volatile_partbound_test
    VALUES (CURRENT_TIMESTAMP);

SELECT
    tableoid::regclass
FROM
    volatile_partbound_test;

DROP TABLE volatile_partbound_test;

