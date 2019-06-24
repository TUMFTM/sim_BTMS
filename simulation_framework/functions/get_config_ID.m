function ID = get_config_ID

persistent ID_pers

if isempty(ID_pers)
    ID_pers = 1;  
else
    ID_pers = ID_pers + 1;
end

ID = ID_pers;
   
end