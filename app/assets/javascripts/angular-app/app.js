var APP = angular.module('mealbuilderApp', [
  'ui.router',
  'templates',
  'restangular'
]);

APP.config(['$stateProvider', '$urlRouterProvider', '$locationProvider', 'RestangularProvider',
    function($stateProvider, $urlRouterProvider, $locationProvider, RestangularProvider) {

  $urlRouterProvider.otherwise('/home');
  
  $stateProvider
     
    // HOME STATES AND NESTED VIEWS ========================================
    .state('home', {
        url: '/home',
        templateUrl: 'partial-home.html'
    })
    
    // nested list with custom controller
    .state('home.list', {
        url: '/list',
        templateUrl: 'partial-home-list.html',
        controller: function($scope) {
            $scope.dogs = ['Bernese', 'Husky', 'Goldendoodle'];
        }
    })
    
    // nested list with just some random string data
    .state('home.paragraph', {
        url: '/paragraph',
        template: 'I could sure use a drink right now.'
    })
    
    // ABOUT PAGE AND MULTIPLE NAMED VIEWS =================================
    .state('about', {
        url: '/about',
        views: {
            '': { templateUrl: 'partial-about.html' },
            'columnOne@about': { template: 'Look I am a column!' },
            'columnTwo@about': { 
                templateUrl: 'table-data.html',
                controller: 'scotchController'
            }
        }
        
    })
    .state('prices', {
        url: '/prices',
        templateUrl: 'partial-prices.html'
    })
    .state('contact', {
        url: '/contact',
        templateUrl: 'partial-contact.html'
    });
}]);

// let's define the scotch controller that we call up in the about state
APP.controller('scotchController', function($scope) {
    
  $scope.message = 'test';
 
  $scope.scotches = [
    {
      name: 'Macallan 12',
      price: 50
    },
    {
      name: 'Chivas Regal Royal Salute',
      price: 10000
    },
    {
      name: 'Glenfiddich 1937',
      price: 20000
    }
  ];
    
});