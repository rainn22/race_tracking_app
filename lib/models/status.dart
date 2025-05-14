enum Status {
  notStarted("Not Started"),
  started("In Progress"),
  finished("Finished");

  final String label;

  const Status(this.label); 
}