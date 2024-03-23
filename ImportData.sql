ALTER TABLE HR.EMPLOYEES
MODIFY(EMAIL VARCHAR2(100 BYTE));


-- createing department_id sequence 
DECLARE
   v_max_department_id NUMBER;
BEGIN
   SELECT NVL(MAX(department_id), 0) + 10 INTO v_max_department_id FROM departments;
   EXECUTE IMMEDIATE 'CREATE SEQUENCE departments_seq START WITH ' || v_max_department_id || ' INCREMENT BY 10';
END;

--creating location_id sequence
DECLARE
   v_max_location_id NUMBER;
BEGIN
   SELECT NVL(MAX(location_id), 0) + 100 INTO v_max_location_id FROM locations;
   EXECUTE IMMEDIATE 'CREATE SEQUENCE locations_seq START WITH ' || v_max_location_id || ' INCREMENT BY 100';
END;
--
create or replace procedure import_employee_data is
   cursor temp_curs is
      select * from employees_temp;
   v_job varchar2(100);
   v_dept varchar2(100);
   v_department_id varchar2(100);
   v_job_id varchar2(100);
   v_city varchar2(100);
   v_first_name varchar2(100);
   v_last_name varchar2(100);
   v_email varchar2(100);
   v_hire_date date;
   v_location number; 
   job_exists number;
   city_exists number;
   department_exists number;
   v_salary number;
begin
   for rec in temp_curs
   loop
   
      v_first_name := rec.first_name;
      v_last_name := rec.last_name;
      v_email := rec.email;
      v_hire_date := to_date(rec.hire_date, 'dd-mm-yyyy');
      v_salary := rec.salary;      
      v_job := rec.job_title;
      v_dept := rec.department_name;
      v_city := rec.city;
        
      -- Check if v_job is not already in the jobs table
      select count(*)
      into job_exists
      from jobs
      where job_title = v_job;

      if job_exists = 0 then
         -- Insert the unique job title into the jobs table
         insert into jobs (job_id, job_title)
         values (substr(v_job, 1, 3), v_job);
                  select job_id into v_job_id from jobs where rec.job_title = job_title;

      else 
         select job_id into v_job_id from jobs where rec.job_title = job_title;
      end if;

      -- Check if v_city is not already in the locations table
      select count(*)
      into city_exists
      from locations
      where city = v_city;

      if city_exists = 0 then
         -- Insert the new city into the locations table
         insert into locations (location_id, city)
         values (locations_seq.nextval, v_city);
          select location_id into v_location  from locations
         where city = v_city;
      else
         -- Retrieve the location_id for the existing location
         select location_id into v_location  from locations
         where city = v_city;
      end if;
      -- Check if v_dept is not already in the departments table
      select count(*)
      into department_exists
      from departments
      where department_name = v_dept;

      if department_exists = 0 then
         -- Insert the unique department into the departments table
         insert into departments (department_id, department_name, location_id)
         values (departments_seq.nextval, v_dept, v_location);
             select department_id into v_department_id from departments where rec.department_name = department_name;

      else 
         select department_id into v_department_id from departments where rec.department_name = department_name;
      end if;

      if v_email like '%@%' then 
         insert into employees (first_name, last_name, email, hire_date, job_id, salary, department_id)
         values (v_first_name, v_last_name, v_email, v_hire_date, v_job_id, v_salary, v_department_id);
      end if;

   end loop;
end import_employee_data;

