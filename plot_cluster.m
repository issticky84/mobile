function plot_cluster()
    X = [randn(1000,2)+ones(1000,2);...
         randn(1000,2)-ones(1000,2)];
    opts = statset('Display','final');

    [idx,ctrs] = kmeans(X,5,...
                        'Distance','city',...
                        'Replicates',5,...
                        'Options',opts);


    plot(X(idx==1,1),X(idx==1,2),'.','color',[1.0 0.0 0.0],'MarkerSize',12)
    hold on
    plot(X(idx==2,1),X(idx==2,2),'.','color','b','MarkerSize',12)
    hold on
    plot(X(idx==3,1),X(idx==3,2),'.','color','g','MarkerSize',12)
    hold on
    plot(X(idx==4,1),X(idx==4,2),'.','color','y','MarkerSize',12)
    hold on
    plot(X(idx==5,1),X(idx==5,2),'.','color','m','MarkerSize',12)
    plot(ctrs(:,1),ctrs(:,2),'kx',...
         'MarkerSize',12,'LineWidth',2)
    plot(ctrs(:,1),ctrs(:,2),'ko',...
         'MarkerSize',12,'LineWidth',2)
    legend('Cluster 1','Cluster 2','Cluster 3','Centroids',...
           'Location','NW')    
end