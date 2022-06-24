% FOR VISUALISATION ONLY!
% DO NOT CHANGE ANYTHING IN THIS FILE!

% Zeglarz plynie lodka od startu do mety uczac sie omijac przeszkody oraz
% zdobywac nagrody .
close

number_of_episodes = 10                    % liczba epizodow wizualizaacji


for episode=1:number_of_episodes
   state = [ceil(rand*length(reward_map(:,1))) 1]; % losowe pole z pierwszej kolumny
   
   the_end = 0;
   nr_pos = 0;
   reward_map_curr = reward_map;
   sum_of_rewards(episode) = 0;
   tab_akcji = [];
   tab_stanow = [];
   while (the_end == 0)
      nr_pos = nr_pos + 1;                            % numer posuniecia
      
      
      % Wybor akcji: 
      [wart_oceny najlepsza_akcja] = max(Q(state(1),state(2),:)); 
      action = najlepsza_akcja; 
         
      [state_next, reward,reward_map_curr] = environment(state, action, reward_map_curr); 
          
      tab_akcji = [tab_akcji action];
      tab_stanow = [tab_stanow state'];
      sum_of_rewards(episode) = sum_of_rewards(episode) + reward;
      
      state = state_next;      % przejscie do nastepnego stanu
      
      
      % wizualizacja przeplywu:
      draw(reward_map_curr,Q, state);
      title(sprintf('episode = %d, move = %d, sum of rewards = %f',episode,nr_pos,sum_of_rewards(episode)));
      pause(0.5)
      
      
      % Koniec epizodu jesli uzyskano maksymalna liczbe krokow lub
      % dojechano do mety
      if (nr_pos == num_os_steps_max || state(2) == length(reward_map(1,:)))
         the_end = 1;                                  
      end
   end % while
   sprintf('average sum of rewards = %f',mean(sum_of_rewards))
end


