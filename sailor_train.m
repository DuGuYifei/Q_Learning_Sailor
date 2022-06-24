
% Sailor sails from start to finish learning to avoid obstacles and win prizes.
% Each water field can be accessed from four neighboring fields (left, right, top, bottom).
% Due to the accidental gusts of wind passing to the selected state follows with some probability <1. 
clear

number_of_episodes = 30000                   % number of training epizodes (multi-stage processes) 
gamma = 1.0                                   % discount factor

alpha = 0.01                                % training speed factor
epsilon = 0.4                              % exploration factor

reward_map = load('map.txt');
%reward_map = load('map_small.txt');
%reward_map = load('map_middle.txt');
%reward_map = load('map_easy.txt');
%reward_map = load('map_big.txt');
%reward_map = load('map_spiral.txt');

num_os_steps_max = ceil(2.5*sum(size(reward_map)))    % maximum number of steps in an episode


Q = zeros( [size(reward_map) 4]);     % trained usability table of <state,action> pairs

% action: 1 - right, 2 - up, 3 - left, 4 - down
for episode=1:number_of_episodes 
   sum_of_rewards(episode) = 0;
   %1. Choose a random, non-terminal state for the agent to begin this new episode.
   stateX = randi(size(reward_map, 1));
   stateY = randi(size(reward_map, 2));
   step = 0;
   rewardMapCurr = reward_map;
   
   while step < num_os_steps_max && stateY ~= size(reward_map, 2)
       step = step + 1;
       state = [stateX, stateY];
       %2. Choose an action (1 - right, 2 - up, 3 - left, 4 - bottom) for the current state. 
       %   Actions will be chosen using an *epsilon greedy algorithm*. 
       %   This algorithm will usually choose the most promising action for the AI agent, 
       %   but it will occasionally choose a less promising option in order to encourage the agent to explore the environment.
       if rand() > epsilon
          maxmum = max([
               Q(stateX,stateY,1),
               Q(stateX,stateY,2),
               Q(stateX,stateY,3),
               Q(stateX,stateY,4)
               ]);
           action = find(Q(stateX,stateY,:) == maxmum);
           if length(action) > 1
               action = action(randi(length(action)));
           end
       else
           action = randi(4);
       end
       
       %3. Perform the chosen action, transition to the next state (i.e., move to the next location),
       %   and receive the reward for moving to the new state:
       [next_state, reward, rewardMapCurr] = environment(state, action, rewardMapCurr);  
       %4  Update the sum of rewards for the current episode:
       sum_of_rewards(episode) = sum_of_rewards(episode) + reward;
       
       %4. Update the Q-value for the previous state and action pair.
       Q(stateX, stateY, action) = Q(stateX, stateY, action) + alpha * ( reward + gamma * max(Q(next_state(1), next_state(2), :)) - Q(stateX, stateY, action));
       stateX = next_state(1);
       stateY = next_state(2);
       %5. If the number of steps equals num_os_steps_max or the sailor reached the last column, end the episode,
       %   otherwise increment the number of steps and go to 2.
   end

   if mod(episode,500)==0
       sprintf('episode = %d average sum of rewards = %f',episode,mean(sum_of_rewards))
   end
end
sprintf('average sum of rewards = %f',mean(sum_of_rewards))
save Q Q 
draw(reward_map,Q);
reward_map
