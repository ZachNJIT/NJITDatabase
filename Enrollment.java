// Enrollment and Course Roster Manager
import java.sql.*;
import java.awt.*;
import java.awt.event.*;
import java.util.*;
import java.util.List;
import javax.swing.*;
import javax.swing.event.ChangeEvent;

public class Enrollment extends JFrame {
    private Connection connection;
    private Statement statement;
    private ResultSet resultSet;
    private Container container;
    private JLabel greetingText, greetingText2, courseRosterText, courseRosterText2;
    private JPanel tab1, tab2;
    private JTable table, table2;
    private JTextField dept, course, section, dept2, course2, section2;
    private JButton addCourse, dropCourse, courseRoster;
    private final int MAXHOURS = 15;
    private String studentName, sSsn, deptName, courseName, staffName, staffID;
    private String wDay, wDay2, startTime, endTime;
    String choice;
    private int dpt, crs, sct, dpt2, crs2, sct2, studentID, crsExists;
    private int addHours, crdHours, currEnroll, maxEnroll, isEnroll;
    private int isConflict, visiteds=0, visitedt=0;
    private List classDetails;
    private JTabbedPane tabbedPane;

    public Enrollment() {
        super( "Course Manager" );

// The URL specifying the books database to which this program connects to using JDBC
        String url = "jdbc:mysql://localhost/njit";

// Load the driver to allow connection to the database
        try {
            connection = DriverManager.getConnection(url, "deitel", "deitel");
            statement = connection.createStatement();
        }
        catch ( SQLException sqlex ) {
            System.err.println( "Unable to connect" );
            sqlex.printStackTrace();
            System.exit( 1 ); // terminate program
        }

        do {
            choice = JOptionPane.showInputDialog("Type C to add classes\nor R to access rosters");
        } while (!(choice.equals("C")||choice.equals("R")));

        JMenu changeMenu = new JMenu("Change...");
        changeMenu.setMnemonic('C');

        JMenuItem studentItem = new JMenuItem("Change Student...");
        studentItem.setMnemonic('S');
        changeMenu.add(studentItem);
        studentItem.addActionListener(
                new ActionListener() {
                    @Override
                    public void actionPerformed(ActionEvent event) {
                        do {
                            studentID = Integer.parseInt(JOptionPane.showInputDialog("Enter Student ID: "));
                        } while(!isValidS(studentID));
                        updateStudent(studentID);
                        greetingText.setText("Welcome " + studentName + "! Please enter the details of the course you would like to add or drop.");
                        visiteds++;
                        tabbedPane.setSelectedIndex(0);
                        repaint();
                        getTable();
                    }
                }
        );

        JMenuItem staffItem = new JMenuItem("Change Staff ID...");
        staffItem.setMnemonic('F');
        changeMenu.add(staffItem);
        staffItem.addActionListener(
                new ActionListener() {
                    @Override
                    public void actionPerformed(ActionEvent event) {
                        do {
                            staffID = JOptionPane.showInputDialog("Enter Staff ID: " );
                        } while(!isValidT(staffID));
                        updateStaff(staffID);
                        greetingText2.setText("Welcome " + staffName + ". Please enter the details of the course of which you would like to view the roster.");
                        visitedt++;
                        tabbedPane.setSelectedIndex(1);
                        repaint();
                    }
                }
        );

        JMenuItem exitItem = new JMenuItem("Exit");
        exitItem.setMnemonic('F');
        changeMenu.add(exitItem);
        exitItem.addActionListener(
                new ActionListener() {
                    @Override
                    public void actionPerformed(ActionEvent event) {
                        System.exit(0);
                    }
                }
        );

        JMenuBar bar = new JMenuBar();
        setJMenuBar(bar);
        bar.add(changeMenu);

        tabbedPane = new JTabbedPane();

// if connected to database, set up GUI for tab 1, the Add Courses tab
        greetingText = new JLabel( "Welcome " + studentName + "! Please enter the details of the course of which you would like to view the roster.");
        JPanel topPanel = new JPanel();
        topPanel.setLayout( new FlowLayout() );
        topPanel.add(greetingText);

// create text fields for course information
        JPanel centerPanel = new JPanel();
        centerPanel.setLayout( new FlowLayout() );

        centerPanel.add( new JLabel( "Department: " ) );
        dept = new JTextField( 2);
        centerPanel.add(dept);

        centerPanel.add( new JLabel( "Course Number: " ) );
        course = new JTextField( 3);
        centerPanel.add(course);

        centerPanel.add( new JLabel( "Section: " ) );
        section = new JTextField( 3);
        centerPanel.add(section);

        addCourse = new JButton( "Add Course" );
        addCourse.addActionListener( new ButtonHandler() );
        centerPanel.add(addCourse);

        dropCourse = new JButton("Drop Course");
        dropCourse.addActionListener(new ButtonHandler());
        centerPanel.add(dropCourse);

        JPanel inputPanel = new JPanel();
        inputPanel.setLayout( new BorderLayout() );
        inputPanel.add( topPanel, BorderLayout.NORTH );
        inputPanel.add( centerPanel, BorderLayout.CENTER );

        JPanel middlePanel = new JPanel();
        middlePanel.setLayout( new FlowLayout() );
        middlePanel.add(new JLabel("Your Current Courses:"));

        JPanel inputPanel2 = new JPanel();
        inputPanel2.setLayout( new BorderLayout() );
        inputPanel2.add( inputPanel, BorderLayout.NORTH );
        inputPanel2.add( middlePanel, BorderLayout.CENTER );

        table = new JTable( 4, 4 );

        tab1 = new JPanel();
        tab1.setLayout( new BorderLayout() );
        tab1.add( inputPanel2, BorderLayout.NORTH );
        tab1.add( table, BorderLayout.CENTER );

        tabbedPane.addTab("Add/Drop Courses", tab1);

        if (choice.equals("C")) {
            do {
                studentID = Integer.parseInt(JOptionPane.showInputDialog("Enter Student ID: " ));
            } while(!isValidS(studentID));
            updateStudent(studentID);
            greetingText.setText("Welcome " + studentName + "! Please enter the details of the course you would like to add or drop.");
            repaint();
            getTable();
        }

// Set up GUI for tab 2, the Course Roster tab
        greetingText2 = new JLabel( "Welcome " + staffName + ". Please enter the details of the course of which you would like to view the roster.");
        JPanel topPanel2 = new JPanel();
        topPanel2.setLayout( new FlowLayout() );
        topPanel2.add( greetingText2 );

// create text fields for course information
        JPanel centerPanel2 = new JPanel();
        centerPanel2.setLayout( new FlowLayout() );

        centerPanel2.add( new JLabel( "Department: " ) );
        dept2 = new JTextField( 2);
        centerPanel2.add(dept2);

        centerPanel2.add( new JLabel( "Course Number: " ) );
        course2 = new JTextField( 3);
        centerPanel2.add(course2);

        centerPanel2.add( new JLabel( "Section: " ) );
        section2 = new JTextField( 3);
        centerPanel2.add(section2);

        courseRoster = new JButton( "Get Course Roster" );
        courseRoster.addActionListener( new ButtonHandler() );

        centerPanel2.add(courseRoster);

        JPanel inputPanel3 = new JPanel();
        inputPanel3.setLayout( new BorderLayout() );
        inputPanel3.add( topPanel2, BorderLayout.NORTH );
        inputPanel3.add( centerPanel2, BorderLayout.CENTER );

        courseRosterText2 = new JLabel("No course selected", SwingConstants.CENTER);
        courseRosterText = new JLabel("", SwingConstants.CENTER);
        JPanel middlePanel2 = new JPanel();
        middlePanel2.setLayout( new BorderLayout());
        middlePanel2.add(courseRosterText, BorderLayout.NORTH);
        middlePanel2.add(courseRosterText2, BorderLayout.CENTER);

        JPanel inputPanel4 = new JPanel();
        inputPanel4.setLayout( new BorderLayout() );
        inputPanel4.add( inputPanel3, BorderLayout.NORTH );
        inputPanel4.add( middlePanel2, BorderLayout.CENTER );

        table2 = new JTable( 4, 4 );

        tab2 = new JPanel();
        tab2.setLayout( new BorderLayout() );
        tab2.add( inputPanel4, BorderLayout.NORTH );
        tab2.add( table2, BorderLayout.CENTER );

        if (choice.equals("R")) {
            do {
                staffID = JOptionPane.showInputDialog("Enter Staff ID: " );
            } while(!isValidT(staffID));
            updateStaff(staffID);
            greetingText2.setText("Welcome " + staffName + ". Please enter the details of the course of which you would like to view the roster.");
            repaint();
        }

        tabbedPane.addTab("Course Rosters", tab2);
        tabbedPane.addChangeListener(this::stateChanged);

        container = getContentPane();

        add(tabbedPane);

        if (choice.equals("R")) {
            tabbedPane.setSelectedIndex(1);
        }

        setSize( 800, 500 );
        setVisible( true );

    } // end constructor

    private void updateStaff (String staffID) {
        try {
            PreparedStatement pstmt = connection.prepareStatement("SELECT tName, tssn FROM staff WHERE tssn=?");
            pstmt.setString(1, staffID);
            resultSet = pstmt.executeQuery();
            while(resultSet.next()) {
                staffName = resultSet.getString("tName");
            }
        } catch ( SQLException sqlex ) {
            sqlex.printStackTrace();
        }
    }

    private void updateStudent (int stdtID) {
        try {
            PreparedStatement pstmt = connection.prepareStatement("SELECT sName, sssn FROM student WHERE sid=?");
            pstmt.setInt(1, stdtID);
            resultSet = pstmt.executeQuery();
            while(resultSet.next()) {
                studentName = resultSet.getString("sName");
                sSsn = resultSet.getString("sssn");
            }
        } catch ( SQLException sqlex ) {
            sqlex.printStackTrace();
        }
    }

    public boolean isValidS(int stdtID) {
        boolean temp = false;
        try {
            PreparedStatement pstmt = connection.prepareStatement("SELECT COUNT(*) FROM student WHERE sid=?");
            pstmt.setInt(1, stdtID);
            resultSet = pstmt.executeQuery();
            if (getSingleInt(resultSet) > 0) {
                temp = true;
            }
        } catch ( SQLException sqlex ) {
            sqlex.printStackTrace();
        }
        return temp;
    }

    public boolean isValidT(String stID) {
        boolean temp = false;
        try {
            PreparedStatement pstmt = connection.prepareStatement("SELECT COUNT(*) FROM staff WHERE tssn=?");
            pstmt.setString(1, stID);
            resultSet = pstmt.executeQuery();
            if (getSingleInt(resultSet) > 0) {
                temp = true;
            }
        } catch ( SQLException sqlex ) {
            sqlex.printStackTrace();
        }
        return temp;
    }


    private void getTable() {
        try {
            PreparedStatement pstmt = connection.prepareStatement("SELECT * FROM (SELECT dName as Department, r.cn as Course, r.sNo as Section, " +
                    "cName as Name, weekDay as Day, startAt as StartTime, endAt as EndTime FROM student s, register r, " +
                    "sr, department d, course c WHERE r.did=d.did AND r.sssn=s.sssn AND sr.did=r.did AND sr.cn=r.cn AND " +
                    "sr.sNo=r.sNo AND c.cn=r.cn AND c.cn=sr.cn AND r.did=c.did AND sr.did=c.did AND s.sid=?) a");
            pstmt.setInt(1, studentID);
            resultSet = pstmt.executeQuery();
            displayResultSet( resultSet );
        } catch ( SQLException sqlex ) {
            sqlex.printStackTrace();
        }
    }

    private void getTable2() {
        try {
            PreparedStatement pstmt = connection.prepareStatement("SELECT * FROM department");
            resultSet = pstmt.executeQuery();
            displayResultSet2( resultSet );
        } catch ( SQLException sqlex ) {
            sqlex.printStackTrace();
        }
    }

    private void addCourse( String query ) {
        try {
            statement = connection.createStatement();
            statement.executeUpdate( query );
            getTable();
        } catch ( SQLException sqlex ) {
            sqlex.printStackTrace();
        }
    }

    private void displayResultSet( ResultSet rs ) throws SQLException {
// position to first record
        boolean moreRecords = rs.next();

// if there are no records, display a message
        if ( !moreRecords ) {
            JOptionPane.showMessageDialog( this,
                    "You are not enrolled in any classes" );
            Vector columnHeads = new Vector();
            Vector rows = new Vector();
            ResultSetMetaData rsmd = rs.getMetaData();
            for ( int i = 1; i <= rsmd.getColumnCount(); ++i )
                columnHeads.addElement( rsmd.getColumnName( i ) );
            table = new JTable( rows, columnHeads );
            JScrollPane scroller = new JScrollPane( table );
            tab1.remove( 1 );
            tab1.add( scroller, BorderLayout.CENTER );
            tab1.validate();
            return;
        }

        Vector columnHeads = new Vector();
        Vector rows = new Vector();

        try {
// get column heads
            ResultSetMetaData rsmd = rs.getMetaData();

            for ( int i = 1; i <= rsmd.getColumnCount(); ++i )
                columnHeads.addElement( rsmd.getColumnName( i ) );
// get row data
            do {
                rows.addElement( getNextRow( rs, rsmd ) );
            } while ( rs.next() );

// display table with ResultSet contents
            table = new JTable( rows, columnHeads );
            JScrollPane scroller = new JScrollPane( table );
            tab1.remove( 1 );
            tab1.add( scroller, BorderLayout.CENTER );
            tab1.validate();
        } catch ( SQLException sqlex ) {
            sqlex.printStackTrace();
        }

    } // end method displayResultSet

    private int getSingleInt( ResultSet rs) throws SQLException {
        boolean moreRecords = rs.next();
// if there are no records, display a message
        if ( !moreRecords ) {
            JOptionPane.showMessageDialog( this,
                    "Could not find course(s)" );
            return 0;
        }

        Vector columnHeads = new Vector();
        Vector currentRow = new Vector();

        try {
// get column heads
            ResultSetMetaData rsmd = rs.getMetaData();
            for ( int i = 1; i <= rsmd.getColumnCount(); ++i )
                columnHeads.addElement( rsmd.getColumnName( i ) );
            for ( int i = 1; i <= rsmd.getColumnCount(); ++i )
                currentRow.addElement(new Integer(rs.getInt(i)));
        } catch ( SQLException sqlex ) {
            sqlex.printStackTrace();
        }
        return (Integer) currentRow.get(0);
    }

    private void displayResultSet2( ResultSet rs ) throws SQLException {
// position to first record
        boolean moreRecords = rs.next();

// if there are no records, display a message
        if ( !moreRecords ) {
            JOptionPane.showMessageDialog( this,
                    "This course is empty" );
            Vector columnHeads = new Vector();
            Vector rows = new Vector();
            ResultSetMetaData rsmd = rs.getMetaData();
            for ( int i = 1; i <= rsmd.getColumnCount(); ++i )
                columnHeads.addElement( rsmd.getColumnName( i ) );
            table2 = new JTable( rows, columnHeads );
            JScrollPane scroller = new JScrollPane( table2 );
            tab2.remove( 1 );
            tab2.add( scroller, BorderLayout.CENTER );
            tab2.validate();
            return;
        }

        Vector columnHeads = new Vector();
        Vector rows = new Vector();

        try {
// get column heads
            ResultSetMetaData rsmd = rs.getMetaData();
            for ( int i = 1; i <= rsmd.getColumnCount(); ++i )
                columnHeads.addElement( rsmd.getColumnName( i ) );
// get row data
            do {
                rows.addElement( getNextRow( rs, rsmd ) );
            } while ( rs.next() );
// display table with ResultSet contents
            table2 = new JTable( rows, columnHeads );
            JScrollPane scroller = new JScrollPane( table2 );
            tab2.remove( 1 );
            tab2.add( scroller, BorderLayout.CENTER );
            tab2.validate();
        } catch ( SQLException sqlex ) {
            sqlex.printStackTrace();
        }

    } // end method displayResultSet

    private Vector getNextRow( ResultSet rs, ResultSetMetaData rsmd ) throws SQLException {
        Vector currentRow = new Vector();

        for ( int i = 1; i <= rsmd.getColumnCount(); ++i )
            switch( rsmd.getColumnType( i ) ) {
                case Types.CHAR:
                case Types.VARCHAR:
                case Types.LONGVARCHAR:
                    currentRow.addElement( rs.getString( i ) );
                    break;
                case Types.INTEGER:
                    currentRow.addElement( new Long( rs.getLong( i ) ) );
                    break;
                case Types.REAL:
                    currentRow.addElement( new Float( rs.getDouble( i ) ) );
                    break;
                case Types.DATE:
                    currentRow.addElement( rs.getDate( i ) );
                    break;
                case Types.TIME:
                    currentRow.addElement( rs.getTime( i ));
                    break;
                case Types.DECIMAL:
                    currentRow.addElement(new Integer(rs.getInt(i)));
                    break;
                default:
                    System.out.println( "Type was: " + rsmd.getColumnTypeName( i ) );
            }

        return currentRow;

    } // end method getNextRow

    public void shutDown() {
        try {
            connection.close();
        }
        catch ( SQLException sqlex ) {
            System.err.println( "Unable to disconnect" );
            sqlex.printStackTrace();
        }
    }

    public static void main( String[] args ) {
        final Enrollment application = new Enrollment();
        application.addWindowListener(
                new WindowAdapter() {
                    public void windowClosing( WindowEvent e ) {
                        application.shutDown();
                        System.exit( 0 );
                    }
                }
        );
    }

    private static List<Map<String, Object>> map(ResultSet rs) throws SQLException {
        List<Map<String, Object>> results = new ArrayList<Map<String, Object>>();
        try {
            if (rs != null) {
                ResultSetMetaData meta = rs.getMetaData();
                int numColumns = meta.getColumnCount();
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<String, Object>();
                    for (int i = 1; i <= numColumns; ++i) {
                        String name = meta.getColumnName(i);
                        Object value = rs.getObject(i);
                        row.put(name, value);
                    }
                    results.add(row);
                }
            }
        } finally {
            rs.close();
        }
        return results;
    }

    public void stateChanged(ChangeEvent e) {
        JTabbedPane tabbedPane = (JTabbedPane) e.getSource();
        int selectedIndex = tabbedPane.getSelectedIndex();
        if (selectedIndex==0 && visiteds==0 && !choice.equals("C")) {
            visiteds++;
            do {
                studentID = Integer.parseInt(JOptionPane.showInputDialog("Enter Student ID: " ));
            } while(!isValidS(studentID));
            updateStudent(studentID);
            greetingText.setText("Welcome " + studentName + "! Please enter the details of the course you would like to add or drop.");
            repaint();
            getTable();
        }
        if (selectedIndex==1 && visitedt==0 && !choice.equals("R")) {
            visitedt++;
            do {
                staffID = JOptionPane.showInputDialog("Enter Staff ID: " );
            } while(!isValidT(staffID));
            updateStaff(staffID);
            greetingText2.setText("Welcome " + staffName + ". Please enter the details of the course of which you would like to view the roster.");
            repaint();
            getTable();
        }
    }

    // inner class ButtonHandler handles button event
    private class ButtonHandler implements ActionListener {

        public void actionPerformed( ActionEvent event ) {
            maxEnroll = 0;
            currEnroll = 0;

            if ( event.getSource() == addCourse) {
                dpt = Integer.parseInt(dept.getText());
                crs = Integer.parseInt(course.getText());
                sct = Integer.parseInt(section.getText());

                // find how many credit hours the course to be added is
                try {
                    PreparedStatement getHours = connection.prepareStatement("SELECT credit FROM course WHERE did=? AND cn=?");
                    getHours.setInt(1,dpt);
                    getHours.setInt(2,crs);
                    resultSet = getHours.executeQuery();
                    addHours = getSingleInt(resultSet);
                    if (addHours == 0) { // if no such course exists, return
                        return;
                    }
                } catch (SQLException exception) {
                    exception.printStackTrace();
                }

                // find how many hours the student is enrolled in
                try {
                    PreparedStatement checkCourses = connection.prepareStatement("SELECT sum(credit) as totalCredit " +
                            "FROM (SELECT DISTINCT c.did, c.cn, credit " +
                            "FROM course c, (SELECT DISTINCT * " +
                            "FROM (SELECT r.did, r.cn " +
                            "FROM student s, register r, sr, department d, course c " +
                            "WHERE r.did=d.did AND r.sssn=s.sssn AND sr.did=r.did AND sr.cn=r.cn " +
                            "AND sr.sNo=r.sNo AND c.cn=r.cn AND c.cn=sr.cn AND r.did=c.did AND sr.did=c.did AND s.sid=?) a) b " +
                            "WHERE c.cn=b.cn " +
                            "AND c.did=b.did) d");
                    checkCourses.setInt(1, studentID);
                    resultSet = checkCourses.executeQuery();
                    crdHours = getSingleInt(resultSet);
                } catch (SQLException exception) {
                    exception.printStackTrace();
                }

                // Make sure student doesn't enroll in too many courses
                if (crdHours + addHours > MAXHOURS) {
                    JFrame frame = new JFrame("Too many courses");
                    JOptionPane.showMessageDialog( frame,"You may only enroll in " + MAXHOURS + " credit hours maximum.\nIf you wish to add this class,\nyou must drop another class first." );
                    return;
                }

                // Check to see if student is already enrolled in a different section of course
                try {
                    PreparedStatement boolEnroll = connection.prepareStatement("SELECT COUNT(*) as enrolled " +
                            "FROM register " +
                            "WHERE sssn=? " +
                            "AND did=? " +
                            "AND cn=? ");
                    boolEnroll.setString(1,sSsn);
                    boolEnroll.setInt(2,dpt);
                    boolEnroll.setInt(3,crs);
                    resultSet = boolEnroll.executeQuery();
                    isEnroll = getSingleInt(resultSet);
                } catch (SQLException exception) {
                    exception.printStackTrace();
                }

                if (isEnroll != 0) {
                    JFrame frame = new JFrame("Already enrolled");
                    JOptionPane.showMessageDialog( frame,"You are already enrolled in\n a section of that course.\nPlease try another course." );
                    return;
                }

                // Check to make sure student does not have time conflict
                try {
                    PreparedStatement boolConflict = connection.prepareStatement("SELECT COUNT(*) " +
                            "FROM (SELECT weekDay, startAt, endAt " +
                            "FROM sr " +
                            "WHERE sr.did=? " +
                            "AND sr.cn=? " +
                            "AND sr.sNo=?) a, " +
                            "(SELECT weekDay, startAt, endAt " +
                            "FROM register r, sr " +
                            "WHERE sssn=? " +
                            "AND r.did=sr.did " +
                            "AND r.cn=sr.cn " +
                            "AND r.sNO=sr.sNo) b " +
                            "WHERE (a.weekDay=b.weekDay " +
                            "AND a.startAt=b.startAt) " +
                            "OR (a.weekDay=b.weekDay " +
                            "AND a.endAt=b.endAt) " +
                            "OR (a.weekDay=b.weekDay " +
                            "AND a.startAt<b.startAt " +
                            "AND b.startAt < a.endAt) " +
                            "OR (a.weekDay=b.weekDay " +
                            "AND a.startAT<b.endAt " +
                            "AND b.endAt<a.endAt)");
                    boolConflict.setInt(1,dpt);
                    boolConflict.setInt(2,crs);
                    boolConflict.setInt(3,sct);
                    boolConflict.setString(4,sSsn);
                    resultSet = boolConflict.executeQuery();
                    isConflict = getSingleInt(resultSet);
                } catch (SQLException exception) {
                    exception.printStackTrace();
                }

                if (isConflict != 0) {
                    JFrame frame = new JFrame("Time Conflict");
                    JOptionPane.showMessageDialog( frame,"You are already enrolled in\n a course at that time.\nPlease try another course." );
                    return;
                }

                // Get maximum enrollment of course to be added
                try {
                    PreparedStatement getEnroll = connection.prepareStatement("SELECT maxEnroll FROM section WHERE did=? AND cn=? AND sNo=?");
                    getEnroll.setInt(1,dpt);
                    getEnroll.setInt(2,crs);
                    getEnroll.setInt(3,sct);
                    resultSet = getEnroll.executeQuery();
                    maxEnroll = getSingleInt(resultSet);
                } catch (SQLException exception) {
                    exception.printStackTrace();
                }

                // Get current enrollment of course to be added
                try {
                    PreparedStatement crntEnroll = connection.prepareStatement("SELECT COUNT(*) as currEnroll " +
                            "FROM (SELECT sid, sssn " +
                            "FROM student, department " +
                            "WHERE major=did) s, register r " +
                            "WHERE s.sssn=r.sssn " +
                            "AND did=? " +
                            "AND cn=? " +
                            "AND sNo=?");
                    crntEnroll.setInt(1,dpt);
                    crntEnroll.setInt(2,crs);
                    crntEnroll.setInt(3,sct);
                    resultSet = crntEnroll.executeQuery();
                    currEnroll = getSingleInt(resultSet);
                } catch (SQLException exception) {
                    exception.printStackTrace();
                }

                // Make sure course isn't full
                if (currEnroll == maxEnroll && maxEnroll != 0) {
                    JFrame frame = new JFrame("Course is full");
                    JOptionPane.showMessageDialog( frame,"This course is full, please select another course" );
                    return;
                }

                // If student's schedule isn't full and course isn't full, enroll them in course
                try {
                    PreparedStatement insertQuery = connection.prepareStatement("INSERT INTO register VALUES (?, ?, ?, ?)");
                    insertQuery.setString(1, sSsn);
                    insertQuery.setInt(2, dpt);
                    insertQuery.setInt(3, crs);
                    insertQuery.setInt(4, sct);
                    insertQuery.executeUpdate();
                } catch (SQLException exception) {
                    exception.printStackTrace();
                }

                // Display updated course schedule
                try {
                    PreparedStatement pstmt = connection.prepareStatement("SELECT * FROM (SELECT dName as Department, r.cn as Course, r.sNo as Section," +
                            "cName as Name, weekDay as Day, startAt as StartTime, endAt as EndTime FROM student s, register r, " +
                            "sr, department d, course c WHERE r.did=d.did AND r.sssn=s.sssn AND sr.did=r.did AND sr.cn=r.cn AND " +
                            "sr.sNo=r.sNo AND c.cn=r.cn AND c.cn=sr.cn AND r.did=c.did AND sr.did=c.did AND s.sid=?) a");
                    pstmt.setInt(1, studentID);
                    resultSet = pstmt.executeQuery();
                    displayResultSet(resultSet);
                } catch (SQLException exception) {
                    exception.printStackTrace();
                }
            }

            else if ( event.getSource() == dropCourse ) {
                dpt = Integer.parseInt(dept.getText());
                crs = Integer.parseInt(course.getText());
                sct = Integer.parseInt(section.getText());

                // Find out if student is enrolled in course
                try {
                    PreparedStatement boolEnroll = connection.prepareStatement("SELECT COUNT(*) as enrolled " +
                            "FROM register " +
                            "WHERE sssn=? " +
                            "AND did=? " +
                            "AND cn=? " +
                            "AND sNo=?");
                    boolEnroll.setString(1,sSsn);
                    boolEnroll.setInt(2,dpt);
                    boolEnroll.setInt(3,crs);
                    boolEnroll.setInt(4,sct);
                    resultSet = boolEnroll.executeQuery();
                    isEnroll = getSingleInt(resultSet);
                } catch (SQLException exception) {
                    exception.printStackTrace();
                }

                // If course is not in student's schedule, show error message
                if (isEnroll == 0) {
                    JFrame frame = new JFrame("Not enrolled");
                    JOptionPane.showMessageDialog( frame,"You are not enrolled in that course.\nPlease try another course." );
                    return;
                }

                // If class is in student's schedule, delete it
                try {
                    PreparedStatement deleteQuery = connection.prepareStatement("DELETE FROM register WHERE sssn=? AND did=? AND cn=? AND sNo=?");
                    deleteQuery.setString(1, sSsn);
                    deleteQuery.setInt(2, dpt);
                    deleteQuery.setInt(3, crs);
                    deleteQuery.setInt(4, sct);
                    deleteQuery.executeUpdate();
                } catch (SQLException exception) {
                    exception.printStackTrace();
                }

                // Display student's schedule
                try {
                    PreparedStatement pstmt = connection.prepareStatement("SELECT * FROM (SELECT dName as Department, r.cn as Course, r.sNo as Section," +
                            "cName as Name, weekDay as Day, startAt as StartTime, endAt as EndTime FROM student s, register r, " +
                            "sr, department d, course c WHERE r.did=d.did AND r.sssn=s.sssn AND sr.did=r.did AND sr.cn=r.cn AND " +
                            "sr.sNo=r.sNo AND c.cn=r.cn AND c.cn=sr.cn AND r.did=c.did AND sr.did=c.did AND s.sid=?) a");
                    pstmt.setInt(1, studentID);
                    resultSet = pstmt.executeQuery();
                    displayResultSet(resultSet);
                } catch (SQLException exception) {
                    exception.printStackTrace();
                }
            }

            else if ( event.getSource() == courseRoster ) {
                dpt2 = Integer.parseInt(dept2.getText());
                crs2 = Integer.parseInt(course2.getText());
                sct2 = Integer.parseInt(section2.getText());

                // see how many of a given section is in database
                try {
                    PreparedStatement courseExists = connection.prepareStatement("SELECT COUNT(*) FROM section WHERE did=? AND cn=? AND sNo=?");
                    courseExists.setInt(1,dpt2);
                    courseExists.setInt(2,crs2);
                    courseExists.setInt(3,sct2);
                    resultSet = courseExists.executeQuery();
                    crsExists = getSingleInt(resultSet);
                } catch (SQLException exception) {
                    exception.printStackTrace();
                }

                if(crsExists == 0) {
                        JFrame frame = new JFrame("Course does not exist");
                        JOptionPane.showMessageDialog(frame, "That course does not exist.\nPlease try another course.");
                        return;
                }

                try {
                    PreparedStatement pstmt2 = connection.prepareStatement("SELECT Student_ID, LastName, FirstName, Student_Year, Major " +
                            "FROM (SELECT sid as Student_ID, sssn, SUBSTRING(sName, LOCATE(' ', sName) + 1, LENGTH(sName)) AS LastName, " +
                            "SUBSTRING(sName, 1, LOCATE(' ', sName) - 1) AS FirstName, sYear as Student_Year, dName as Major " +
                            "FROM student, department " +
                            "WHERE major=did) s, register r " +
                            "WHERE s.sssn=r.sssn " +
                            "AND did=? " +
                            "AND cn=? " +
                            "AND sNo=? " +
                            "ORDER BY LastName");
                    pstmt2.setInt(1, dpt2);
                    pstmt2.setInt(2, crs2);
                    pstmt2.setInt(3, sct2);
                    resultSet = pstmt2.executeQuery();
                    displayResultSet2(resultSet);
                } catch (SQLException exception) {
                    exception.printStackTrace();
                }

                // Update text above course roster table
                try {
                    PreparedStatement pstmt3 = connection.prepareStatement("SELECT dName, cName, weekDay, startAt, endAt " +
                            "FROM sr, course c, department d " +
                            "WHERE c.did=sr.did "+
                            "AND d.did=c.did " +
                            "AND sr.cn=c.cn " +
                            "AND c.did=? " +
                            "AND c.cn=? " +
                            "AND sr.sNo=?");
                    pstmt3.setInt(1, dpt2);
                    pstmt3.setInt(2, crs2);
                    pstmt3.setInt(3, sct2);
                    classDetails = map(pstmt3.executeQuery());
                    HashMap firstRow = (HashMap) classDetails.get(0);
                    deptName = (String) firstRow.get("dName");
                    courseName = (String) firstRow.get("cName");
                    wDay = (String) firstRow.get("weekDay");
                    startTime = firstRow.get("startAt").toString();
                    endTime = firstRow.get("endAt").toString();
                    if (classDetails.size() == 2) {
                        HashMap secondRow = (HashMap) classDetails.get(1);
                        wDay2 = (String) secondRow.get("weekDay");
                    }
                } catch (SQLException exception) {
                    exception.printStackTrace();
                }
                if (classDetails.size() == 1) {
                    courseRosterText.setText(deptName + " " + crs2 + "." + sct2 + " - " + courseName);
                    courseRosterText2.setText("Meets: " + wDay + " " + startTime + "-" + endTime);
                }
                if (classDetails.size() == 2) {
                    courseRosterText.setText(deptName + " " + crs2 + "." + sct2 + " - " + courseName);
                    courseRosterText2.setText("Meets: " + wDay + ", " + wDay2 + " " + startTime + "-" + endTime);
                }
            }
        } // end method actionPerformed
    } // end inner class ButtonHandler
} // end class Enrollment