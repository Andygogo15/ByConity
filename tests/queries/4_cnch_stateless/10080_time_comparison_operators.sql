select '12:00:00.4566'::Time < '12:00:00.4566'::Time;
select '12:00:00.4566'::Time < '11:00:00.4566'::Time;
select '12:00:00.4566'::Time < '13:00:00.4566'::Time;

select '12:00:00.4566'::Time <= '12:00:00.4566'::Time;
select '12:00:00.4566'::Time <= '11:00:00.4566'::Time;
select '12:00:00.4566'::Time <= '13:00:00.4566'::Time;

select '12:00:00.4566'::Time == '12:00:00.4566'::Time;
select '12:00:00.4566'::Time == '12:00:00.4566'::Time(4);
select '12:00:00.4566'::Time == '11:00:00.4566'::Time;
select '12:00:00.4566'::Time == '13:00:00.4566'::Time;

select '12:00:00.4566'::Time > '12:00:00.4566'::Time;
select '12:00:00.4566'::Time > '12:00:00.4566'::Time(4);
select '12:00:00.4566'::Time > '11:00:00.4566'::Time;
select '12:00:00.4566'::Time > '13:00:00.4566'::Time;

select '12:00:00.4566'::Time >= '12:00:00.4566'::Time;
select '12:00:00.4566'::Time >= '12:00:00.4566'::Time(4);
select '12:00:00.4566'::Time >= '11:00:00.4566'::Time;
select '12:00:00.4566'::Time >= '13:00:00.4566'::Time;

select '12:00:00.4566'::Time <> '12:00:00.4566'::Time;
select '12:00:00.4566'::Time <> '12:00:00.4566'::Time(4);
select '12:00:00.4566'::Time <> '11:00:00.4566'::Time;
select '12:00:00.4566'::Time <> '13:00:00.4566'::Time;

select '12:00:00.4566'::Time != '12:00:00.4566'::Time;
select '12:00:00.4566'::Time != '12:00:00.4566'::Time(4);
select '12:00:00.4566'::Time != '11:00:00.4566'::Time;
select '12:00:00.4566'::Time != '13:00:00.4566'::Time;

select '12:00:00.4566'::Time > CAST('2021 01-02 12:00:00.4566'::DateTime64(4) as Time(3));
select '12:00:00.4566'::Time < CAST('2021 01-02 12:00:00.4566'::DateTime64(4) as Time(3));
select '12:00:00.4566'::Time == CAST('2021 01-02 12:00:00.4566'::DateTime64(4) as Time(3));

select '12:00:00.4566'::Time(4) BETWEEN '11:00:00.4566'::Time(4) AND '12:00:00.4566'::Time(3);
select '12:00:00.4566'::Time(4) BETWEEN '11:00:00.4566'::Time(4) AND '12:00:00.4566'::Time(4);
select '12:00:00.4566'::Time(4) BETWEEN '11:00:00.4566'::Time(4) AND '11:59:00.4566'::Time(4);

select '12:00:00.4566'::Time(4) NOT BETWEEN '11:00:00.4566'::Time(4) AND '12:00:00.4566'::Time(3);
select '12:00:00.4566'::Time(4) NOT BETWEEN '11:00:00.4566'::Time(4) AND '12:00:00.4566'::Time(4);
select '12:00:00.4566'::Time(4) NOT BETWEEN '11:00:00.4566'::Time(4) AND '11:59:00.4566'::Time(4);

select '12:00:00.4566'::Time(4) IN ('11:00:00.4566'::Time(4), '11:00:00.4566'::Time(4));
select '12:00:00.4566'::Time(4) IN ('11:00:00.4566'::Time(4), '12:00:00.4566'::Time(4));
select '12:00:00.4566'::Time(4) IN ('11:00:00.4566'::Time(4), '12:00:00.4566'::Time(3));

select '12:00:00.4566'::Time(4) NOT IN ('11:00:00.4566'::Time(4), '11:00:00.4566'::Time(4));
select '12:00:00.4566'::Time(4) NOT IN ('11:00:00.4566'::Time(4), '12:00:00.4566'::Time(4));
select '12:00:00.4566'::Time(4) NOT IN ('11:00:00.4566'::Time(4), '12:00:00.4566'::Time(3));