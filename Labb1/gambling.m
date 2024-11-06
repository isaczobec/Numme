clearvars, clc

num_samples = 100000;

% variables
max_bets = 1000;
chance_win = 0.45;
win_money_multiplier = 2;
start_money = 1000;
start_bet = 100;

money_vec = ones(1,num_samples) * start_money;
current_bet = ones(1,num_samples) * start_bet;


for i = 1:max_bets
    rand_vals = rand(1,num_samples);
    win_vec = (rand_vals <= chance_win);
    money_delta_vec = win_vec * 2 -1; % -1 if you lost, 1 if you won 
    money_vec = money_vec + money_delta_vec.*current_bet; % change money
    
    % increment bet if you lost, if won reset it to default amount
    current_bet = ((1-win_vec)*win_money_multiplier).*(current_bet) + win_vec*start_bet; % 

    % set money and current bet to 0 for thoose who have no money
    has_money = money_vec >= 0;
    money_vec = money_vec.*has_money;
    current_bet = current_bet.*has_money;

end

disp(['average money:',string(sum(money_vec)/length(money_vec))])
distribution_diagram(money_vec,[0,500000],100,'b')

