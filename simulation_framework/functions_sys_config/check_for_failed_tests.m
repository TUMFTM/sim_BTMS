function bool = check_for_failed_tests(passed)

% Check if any tests is 'false'

bool = size(cell2mat(struct2cell(passed)), 1) > sum(cell2mat(struct2cell(passed)));