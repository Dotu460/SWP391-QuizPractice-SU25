package com.quiz.su25.dal.impl;

import com.quiz.su25.dal.DBContext;
import com.quiz.su25.dal.I_DAO;
import com.quiz.su25.entity.Practice;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PracticeDAO extends DBContext implements I_DAO<Practice> {

    @Override
    public List<Practice> findAll() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean update(Practice t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean delete(Practice t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public int insert(Practice t) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Practice getFromResultSet(ResultSet resultSet) throws SQLException {
        return Practice.builder()
                .id(resultSet.getInt("id"))
                .user_id(resultSet.getInt("user_id"))
                .subject_id(resultSet.getInt("subject_id"))
                .number_of_questions(resultSet.getInt("number_of_questions"))
                .question_selection_type(resultSet.getString("question_selection_type"))
                .selected_topics(resultSet.getString("selected_topics"))
                .selected_dimensions(resultSet.getString("selected_dimensions"))
                .status(resultSet.getString("status"))
                .build();
    }

    @Override
    public Practice findById(Integer id) {
        String sql = "SELECT * FROM Practice WHERE id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, id);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            System.out.println("Error findById at class PracticeDAO: " + e.getMessage());
        } finally {
            closeResources();
        }
         return null;
    }

    public static void main(String[] args) {
        PracticeDAO dao = new PracticeDAO();
        Practice practice = dao.findById(1);
        System.out.println(practice);
    }
    

} 